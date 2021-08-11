--- Opens the arglist in a floating window, each arglist item is on it's own line
-- when exiting the window the arglist is updated to the contents of the buffer.
--
-- TODO
-- * be nice to have an <esc> or <c-c> mapping to close and update as currently moving out of the window
local api = vim.api
local float = require('ui.window.float')
local is_string_list_same = require("util.table").is_string_list_same
local buffer = require("util.buffer")

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
    vim.cmd("argdelete *")
  end
  vim.cmd(string.format("%s %s", "argadd", flat_args))
end

function M.edit_args_in_buffer()
  local arg_list = M.get_arglist()

  -- check if buffer for editing args exists, create if not
  -- if exists ensure it's up to date, update if not
  -- this gives ability to have history in edits as long as not set elsewhere
  if buf then
    local buf_arg_list = buffer.get_all_lines(buf)
    if not is_string_list_same(arg_list, buf_arg_list) then
      api.nvim_buf_set_lines(buf, 0, api.nvim_buf_line_count(buf), false, arg_list)
    end
  else
    buf = api.nvim_create_buf(false, true)
    api.nvim_buf_set_lines(buf, 0, 0, false, arg_list)
  end

  -- callback function to set the arglist with edited buf lines
  local callback = function()
    local buf_arg_list = buffer.get_all_lines(buf)
    M.set_arglist(buf_arg_list)
  end

  local opts = float.gen_centered_float_opts(0.8, 0.8, true)
  float.open_float(buf, opts, callback)
end

function M.setup()
  local command = {
    "command!",
    "-nargs=0",
    "EditArgList",
    "lua require('ui.arglist').edit_args_in_buffer()"
  }
  vim.cmd(table.concat(command, " "))
end

return M
