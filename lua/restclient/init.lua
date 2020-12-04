local api = vim.api
local util = require('util.config')
local parser = require('restclient.parser')
local view = require('restclient.view')
local draw = require('ui.window.draw')
local log = require('util.log')
-- LOG_LEVEL = "DEBUG"
local M = {}

local requests = nil
local next_request_id = 1

local function on_read_callback(err, data)
  local request
  if requests then
    request = requests[next_request_id]
    if request then
      if err then
        -- TODO handle err
        request:add_result_line("ERROR")
        if data then
          request:add_result_line(data)
        end
      end
      if data then
        request.result = data
        -- local vals = vim.split(data, "\n")
        -- for _, d in pairs(vals) do
        --   -- TODO continue not rquired here
        --   if d == "" then goto continue end
        --   request:add_result_line(d)
        --   ::continue::
        -- end
      end
    end
  end
end

local function async_run_curl(run_next_callback)
  local request = requests[next_request_id]
  local curl_args = request:get_curl()

  local stdout = vim.loop.new_pipe(false)
  local stderr = vim.loop.new_pipe(false)

  log.debug("Running cUrl: curl " .. curl_args)
  -- log.debug(vim.inspect(vim.split(curl_args, ' ')))

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

        next_request_id = next_request_id + 1
        run_next_callback()
      end
    )
  )
  vim.loop.read_start(stdout, on_read_callback)
  vim.loop.read_start(stderr, on_read_callback)
end

function M.run_next()
  if requests then
    if requests[next_request_id] then
      async_run_curl(M.run_next)
    end
  end
end

function M.run()
  local buf = api.nvim_win_get_buf(0)
  local filetype = api.nvim_buf_get_option(0, 'filetype')

  if filetype == 'rest' then
    local buf_lines = api.nvim_buf_get_lines(buf, 0, api.nvim_buf_line_count(buf), false)
    requests = parser.parse_lines(buf_lines)
    next_request_id = 1

    view.create_result_scratch_buf()

    draw.open_draw(view.result_buf)

    M.run_next()
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
