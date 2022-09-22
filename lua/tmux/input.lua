local M = {}

--- Calls the tmux display-panes command and prompts user for input
function M.get_pane()
  -- display panes to capture, override template action so if number entered
  -- whilst pane number displayed, tmux doesn't jump to it
  os.execute("tmux display-panes ''")
  local pane = nil
  vim.ui.input({ prompt = "Enter pane: "},
  function(input)
    pane =  input
  end
  )
  return pane
end

return M
