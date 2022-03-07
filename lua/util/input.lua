local api = vim.api
local M = {}

-- TODO add support for setting and unsetting echohl see :help input
function M.get_user_input(prompt, default)
  local opts = { prompt = prompt }
  if default then
    opts["default"] = default
  end

  api.nvim_call_function("inputsave", {})
  local val = api.nvim_call_function("input", { opts })
  api.nvim_call_function("inputrestore", {})
  -- clear the command line
  vim.cmd("normal :<ESC>")

  if val == "" then
    return nil
  end
  return val
end
return M
