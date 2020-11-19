local api = vim.api

local M = {}

--- Calls the tmux display-panes command and prompts user for input
function M.get_pane()
  -- display panes to capture, override template action so if number entered
  -- whilst pane number displayed, tmux doesn't jump to it
  os.execute("tmux display-panes ''")
  local pane = M.get_user_input("Enter pane: ")
  return pane
end

-- TODO move to utils
-- TODO add support for setting and unsetting echohl see :help input
function M.get_user_input(prompt, default)
  local opts = {prompt = prompt}
  if default then
    opts["default"] = default
  end

  api.nvim_call_function("inputsave", {})
  local val = api.nvim_call_function("input", {opts})
  api.nvim_call_function("inputrestore", {})
  -- clear the command line
  api.nvim_command("normal :<ESC>")

  if val == '' then
    return nil
  end
  return val
end

return M
