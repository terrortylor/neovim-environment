local api = vim.api
local util = require('util.config')
local parser = require('httpclient.parser')
local runner = require('httpclient.runner')
local view = require('httpclient.view')
local draw = require('ui.window.draw')
local log = require('util.log')
-- LOG_LEVEL = "DEBUG"
local M = {}
local variables

M.config = {
  -- highlight group to use for message
  progress_running_highlight = "WarningMsg",
  progress_complete_highlight = "WarningMsg",
  -- handlers used to update status and show results
  update_status = view.show_status,
  update_results = view.update_result_buf,
  -- register to put into, when viewing a request curl
  -- if nil then does nothing
  register = "+"
}

function M.get_current()
  local linenr = api.nvim_win_get_cursor(0)[1]
  local lines = {}
  local cur = linenr

  local get_line = function(num)
    local line = api.nvim_buf_get_lines(0, num - 1, num, false)[1]
    if not line then return nil end
    if line:match("^%s*$") then return nil end
    return line
  end

  repeat
    local line = get_line(cur)
    if not line then break end
    table.insert(lines, 1, line)
    cur = cur - 1
  until(cur < 0)

  cur = linenr + 1
  repeat
    local line = get_line(cur)
    if not line then break end
    table.insert(lines, line)
    cur = cur + 1
  until(false)

  return lines
end

local function parse_file()
  local lines = api.nvim_buf_get_lines(0, 0, api.nvim_buf_line_count(0), false)
  local requests
  requests,variables = parser.parse_lines(lines)
  return requests
end

-- FIXME currently broken when inspecting request with missing data
-- FIXME check request with headers...
function M.inspect_curl()
  local filetype = api.nvim_buf_get_option(0, 'filetype')

  if filetype ~= 'http' then
    log.error('Must be filetype: http')
    return
  end

  -- if variables nil then parse file to populate first
  if not variables then
    parse_file()
  end

  local lines = M.get_current()
  local requests,_ = parser.parse_lines(lines) -- luacheck: ignore

  if #requests > 0 then
    local curl = "curl " .. requests[1]:get_curl(variables)
    api.nvim_command("echo '" .. curl .. "'")
    if M.config.register then
      api.nvim_command(string.format('let @%s = "%s"', M.config.register, curl))
    end
  else
    log.error("No request found")
  end

end

function M.run(current)
  current = current or false

  local filetype = api.nvim_buf_get_option(0, 'filetype')

  if filetype ~= 'http' then
    log.error('Must be filetype: http')
    return
  end

  local update_view = function(...)
    if  not M.config.update_results then return end

    M.config.update_results(...)
  end

  local update_status = function(...)
    if not M.config.update_status then return end

    M.config.update_status(M.config.progress_running_highlight, M.config.progress_complete_highlight, ...)
  end

  local requests
  if current then
    -- if variables nil then parse file to populate first
    if not variables then
      parse_file()
    end

    local lines = M.get_current()
    requests,_ = parser.parse_lines(lines) -- luacheck: ignore
  else
    requests = parse_file()
  end

  view.create_result_scratch_buf()
  draw.open_draw(view.result_buf)

  runner.make_requests(requests, variables, update_status, update_view)
end

function M.setup()
  local command = {
    'command!',
    '-nargs=0',
    'HttpclientRunFile',
    "lua require(\"httpclient\").run()"
  }
  api.nvim_command(table.concat(command, ' '))

  command = {
    'command!',
    '-nargs=0',
    'HttpclientRunCurrent',
    "lua require(\"httpclient\").run(true)"
  }
  api.nvim_command(table.concat(command, ' '))

  command = {
    'command!',
    '-nargs=0',
    'HttpclientInspectCurrent',
    "lua require(\"httpclient\").inspect_curl()"
  }
  api.nvim_command(table.concat(command, ' '))

  local autogroups = {
    http_filetype_detect = {
      {"BufNewFile,BufRead", "*.http", "set filetype=http"},
    }
  }

  util.create_autogroups(autogroups)
end

return M
