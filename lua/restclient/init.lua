local api = vim.api
local util = require('util.config')
local parser = require('restclient.parser')
local view = require('restclient.view')
local draw = require('ui.window.draw')
local log = require('util.log')
-- LOG_LEVEL = "DEBUG"
local M = {}

M.config = {
  -- if set will sleep N between running through requests
  -- this is just a call out to bash sleep so defaults to
  -- seconds, use 0.5 for fractions
  wait = nil,
  -- if set echo's progress
  show_progress = true,
  -- highlight group to use for message
  progress_running_highlight = "WarningMsg",
  progress_complete_highlight = "WarningMsg",
}

local requests = nil
local variables = nil
-- some variables for tracking state
local running = false
local requests_complete
local requests_failed
local requests_missing_data


function M.async_curl(request)
  local curl_args = request:get_curl(variables)
  if not curl_args then
--    print("curl is nil")
    return
  end
  request:set_running()

  local stdout = vim.loop.new_pipe(false)
  local stderr = vim.loop.new_pipe(false)

  log.debug("Running cUrl: curl " .. curl_args)
  -- log.debug(vim.inspect(vim.split(curl_args, ' ')))

  local callback = function(err, data)
    request:set_done()
    if err then
      -- TODO handle err
      request:add_result_line("ERROR")
      if data then
        request:add_result_line(data)
      end
      requests_failed = requests_failed + 1
    end
    if data then
      request.result = data
      requests_complete = requests_complete + 1
    end
    M.show_status()
  end

  -- TODO move to func, request would benefit from being class
  local handle
  handle = vim.loop.spawn('curl', {
      args = vim.split(curl_args, ' '),
      stdio = {stdout,stderr}
    },
    vim.schedule_wrap(function()
        stdout:read_stop()
        stderr:read_stop()
        stdout:close()
        stderr:close()
        handle:close()

        view.update_result_buf(requests)
      end
    )
  )
  vim.loop.read_start(stdout, vim.schedule_wrap(callback))
  vim.loop.read_start(stderr, vim.schedule_wrap(callback))
end

function M.is_complete()
  local is_complete = true
  for _,req in pairs(requests) do
    if req:queued() then
      is_complete = false
      break
    end
  end
  return is_complete
end

-- TODO move to view?
function M.show_status()
  local print_status = function(hl, msg)
    api.nvim_command("echohl " .. hl)
    api.nvim_command("echo '" .. msg .. "'")
    api.nvim_command("echohl None")
  end

  if not M.config.show_progress then
    return
  end

  local status
  local hl
  if running then
    status =  string.format("Running: %s of %s complete", requests_complete, #requests)
    hl = M.config.progress_running_highlight
  else
    status =  string.format("Finished %s of %s complete", requests_complete, #requests)
    hl = M.config.progress_complete_highlight
  end
  if requests_missing_data > 0 then
    status = status .. string.format(", %s missing data", requests_missing_data)
  end
  print_status(hl,status)
end

function M.make_requests()
  requests_missing_data = 0
  M.show_status()
  repeat
    for i = 1, #requests do
      local request = requests[i]
      if request:queued() then
        M.async_curl(request)
      end
      if request:missing_data() then
        requests_missing_data = requests_missing_data + 1
      end
      if M.wait then
        os.execute("sleep " .. M.wait)
      end
    end
  until(M.is_complete())
  running = false
end

function M.run()
  running = true
  local buf = api.nvim_win_get_buf(0)
  local filetype = api.nvim_buf_get_option(0, 'filetype')

  if filetype == 'rest' then
    local buf_lines = api.nvim_buf_get_lines(buf, 0, api.nvim_buf_line_count(buf), false)
    requests, variables = parser.parse_lines(buf_lines)

    view.create_result_scratch_buf()
    draw.open_draw(view.result_buf)

    requests_complete = 0
    M.make_requests()
  else
    log.error('Must be filetype: rest')
  end
end

function M.setup()
  local command = {
    'command!',
    '-nargs=0',
    'RestclientRunFile',
    "call luaeval('require(\"restclient\").run()', expand('<args>'))"
  }
  api.nvim_command(table.concat(command, ' '))

  local autogroups = {
    rest_filetype_detect = {
      {"BufNewFile,BufRead", "*.rest", "set filetype=rest"},
      {"BufNewFile,BufRead", "*.rest", "nnoremap <leader>gt :RestclientRunFile<CR>"},
    }
  }

  util.create_autogroups(autogroups)
end

return M
