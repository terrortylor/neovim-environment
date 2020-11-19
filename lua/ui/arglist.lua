-- if package.loaded['ui.arglist'] then package.loaded['ui.arglist'] = nil end
-- TODO
-- popup buffer to display arg list, each item on new line
-- popup buffer to edit arg list like buffer
-- populate arg list from fzf finder
local api = vim.api

local M = {}

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

return M
