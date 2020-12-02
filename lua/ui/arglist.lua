-- if package.loaded['ui.arglist'] then package.loaded['ui.arglist'] = nil end
-- TODO
-- popup buffer to display arg list, each item on new line
-- popup buffer to edit arg list like buffer
-- populate arg list from fzf finder
local api = vim.api
local float = require('util.window.float')
local is_string_list_same = require("util.table").is_string_list_same

local M = {}

local buf

function M.get_arglist()
  local arg_list = {}
  local raw_args = api.nvim_command_output("args")
  local args,_ = raw_args:gsub("[%[%]]", "")
  for v in args:gmatch("%S+") do
    table.insert(arg_list, v)
  end
  return arg_list
end

function M.set_arglist(arg_list)
  local flat_args = table.concat(arg_list, ' ')

  -- Only empty list if not already empty
  local args = api.nvim_command_output("args")
  if args and args ~= "" then
    api.nvim_command("argdelete *")
  end
  api.nvim_command(string.format("%s %s", "argadd", flat_args))
end

function M.edit_args_in_buffer()
  local arg_list = M.get_arglist()

  -- check if buffer for editing args exists, create if not
  -- if exists ensure it's up to date, update if not
  -- this gives ability to have history in edits as long as not set elsewhere
  if buf then
    local buf_arg_list = api.nvim_buf_get_lines(buf, 0, api.nvim_buf_line_count(buf), false)
    if not is_string_list_same(arg_list, buf_arg_list) then
      api.nvim_buf_set_lines(buf, 0, api.nvim_buf_line_count(buf), false, arg_list)
    end
  else
    buf = api.nvim_create_buf(false, true)
    api.nvim_buf_set_lines(buf, 0, 0, false, arg_list)
  end

  -- callback function to set the arglist with edited buf lines
  local callback = function()
    local buf_arg_list = api.nvim_buf_get_lines(buf, 0, api.nvim_buf_line_count(buf), false)
    M.set_arglist(buf_arg_list)
  end

  local opts = float.gen_centered_float_opts(0.8, 0.8, true)
  float.open_float(" Edit arg list ", true, buf, opts, callback)
end

function M.setup()
  local command = {
    "command!",
    "-nargs=0",
    "EditArgList",
    "lua require('ui.arglist').edit_args_in_buffer()"
  }
  api.nvim_command(table.concat(command, " "))
end

return M
