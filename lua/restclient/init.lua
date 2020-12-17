local api = vim.api
local util = require('util.config')
local parser = require('restclient.parser')
local view = require('restclient.view')
local draw = require('ui.window.draw')
local log = require('util.log')
-- LOG_LEVEL = "DEBUG"
local M = {}

local requests = nil

function M.async_curl(request)
  request:set_running()
  local curl_args = request:get_curl()

  local stdout = vim.loop.new_pipe(false)
  local stderr = vim.loop.new_pipe(false)

  log.debug("Running cUrl: curl " .. curl_args)
  -- log.debug(vim.inspect(vim.split(curl_args, ' ')))

  local callback = function(err, data)
    if err then
      -- TODO handle err
      request:add_result_line("ERROR")
      if data then
        request:add_result_line(data)
      end
    end
    if data then
      request.result = data
    end
    request:set_done()
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
        M.make_requests()
      end
    )
  )
  vim.loop.read_start(stdout, callback)
  vim.loop.read_start(stderr, callback)
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

function M.make_requests()
  repeat
    for i = 1, #requests do
      local request = requests[i]
      if request:queued() then
        M.async_curl(request)
      end
    end
  until(M.is_complete())
end

function M.run()
  local buf = api.nvim_win_get_buf(0)
  local filetype = api.nvim_buf_get_option(0, 'filetype')

  if filetype == 'rest' then
    local buf_lines = api.nvim_buf_get_lines(buf, 0, api.nvim_buf_line_count(buf), false)
    requests = parser.parse_lines(buf_lines)

    view.create_result_scratch_buf()
    draw.open_draw(view.result_buf)

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
