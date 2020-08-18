local api = vim.api

-- TODO Some extension ideas:
-- Add tab scoped variables that override command and pane
-- Sanity check there is more than one pane to send too
-- :redraw was used to hide prompt after input before... doesn't seem to work in lua though

-- Initialise some local varirables
local pane_number
local user_command

local M = {}

function capture_pane_number()
  if not pane_number then
    -- any way to prevent switching panes if pressed before numbers disappear
    os.execute('tmux display-panes')

    pane_number = vim.api.nvim_call_function('input', {'Enter pane to send command too: '})
  end
end

function get_pane_number()
  return pane_number
end

function M.clear_pane_number()
  pane_number = nil
end

function capture_user_command()
  if not user_command then
    user_command = vim.api.nvim_call_function('input', {'Enter command to send: '})
  end
end

function get_user_command()
  return user_command
end

function execute_user_command()
  if not pane_number or not user_command then
    print("Missing pane or command, not running")
    return
  end

  vim.api.nvim_command('wa')
  os.execute('tmux send-keys -t "' .. pane_number .. '" C-z "' .. user_command .. '" Enter')
end

function M.clear_user_command()
  user_command = nil
end

function M.send_command_to_pane()
  capture_pane_number()
  capture_user_command()
  execute_user_command()
end


-- export locals for test
if _TEST then
  -- setup test alias for private elements using a modified name
  M._capture_pane_number = capture_pane_number
  M._get_pane_number = get_pane_number
  M._capture_user_command = capture_user_command
  M._get_user_command = get_user_command
  M._execute_user_command = execute_user_command
end

-- Create commands
-- Keeping these in init.vim for now...
-- vim.api.nvim_command("command! -nargs=0 TmuxSendCommandToPane call luaeval('M.send_command_to_pane()', expand('<args>'))")

return M
