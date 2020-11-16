local api = vim.api
local util = require('util.config')
local nresil = util.noremap_silent

-- TODO Some extension ideas:
-- Probably not worth tihs one, see line below - Add tab scoped variables that override command and pane
-- Add ability to store multiple commands/ panes
-- Sanity check there is more than one pane to send too
-- :redraw was used to hide prompt after input before... doesn't seem to work in lua though
-- send Escape before command, so if in copy mode it's escaped first
-- Update TmuxClearCommand to TmuxSetCommand that takes 0 or 1 argument, if 0 then clear it, otherwise set it to given argement

-- Initialise some local varirables
local pane_number
local user_command

local M = {}

-- Define settings
M.mappings = {
  ["<C-PAGEUP>"]   = ":lua require('tmux').scroll(true)<CR>",
  ["<C-PAGEDOWN>"] = ":lua require('tmux').scroll(false)<CR>",
  ["<leader>nn"]   = ":lua require('tmux').send_command_to_pane()<CR>",
}

function M.capture_pane_number()
  if not pane_number or pane_number == '' then
    -- any way to prevent switching panes if pressed before numbers disappear
    os.execute('tmux display-panes')

    pane_number = api.nvim_call_function('input', {'Enter pane to send command too: '})
  end
end

local function get_pane_number()
  return pane_number
end

function M.clear_pane_number()
  pane_number = nil
end

local function capture_user_command()
  if not user_command or user_command == '' then
    user_command = api.nvim_call_function('input', {'Enter command to send: '})
  end
end

local function get_user_command()
  return user_command
end

-- TODO move these to lib so can be mocked easily
function M.execute_user_command(command)
  if not pane_number or pane_number == '' or not command or command == '' then
    print("Missing pane or command, not running")
    return
  end

  api.nvim_command('wa')
  -- if not in normal mode go back to it
  os.execute('tmux if-shell -F -t "' .. pane_number .. '" "#{pane_in_mode}" "send-keys Escape" ""')
  -- run command
  os.execute('tmux send-keys -t "' .. pane_number .. '" C-z "' .. command .. '" Enter')
end

function M.clear_user_command()
  user_command = nil
end

function M.send_command_to_pane()
  M.capture_pane_number()
  capture_user_command()

  M.execute_user_command(user_command)
end

function M.send_one_off_command_to_pane()
  M.capture_pane_number()
  -- TODO should not run if pane not set
  local one_off_command = api.nvim_call_function('input', {'Enter command: '})
  if not pane_number or pane_number == '' then
    print('No pane set')
  else
    if one_off_command then
      M.execute_user_command(one_off_command)
    else
      print('No command captured!')
    end
  end
end

-- Used to scroll a pane up/down
-- @param up True/False, should scroll up
function M.scroll(up)
  M.capture_pane_number()
  -- ensure in copy-mode
  os.execute('tmux if-shell -F -t "' .. pane_number .. '" "#{pane_in_mode}" "" "copy-mode"')
  -- run scroll command
  local direction = "halfpage-down"
  if up then
    direction = "halfpage-up"
  end
  os.execute('tmux send-keys -t "' .. pane_number .. '" -X ' .. direction)
end

-- Create commands and setup mappings
-- TODO add test
function M.setup()
  -- Create Commands
  -- TODO if argument passed then use that as command, no panel number behaviour change
  local command = {
    "command!",
    "-nargs=0",
    "TmuxSendCommandToPane",
    "call luaeval('require(\"tmux\").send_command_to_pane()', expand('<args>'))"
  }
  api.nvim_command(table.concat(command, " "))

  command = {
    "command!",
    "-nargs=0",
    "TmuxSendOneOffCommandToPane",
    "call luaeval('require(\"tmux\").send_one_off_command_to_pane()', expand('<args>'))"
  }
  api.nvim_command(table.concat(command, " "))

  command = {
    "command!",
    "-nargs=0",
    "TmuxSetPane",
    "call luaeval('require(\"tmux\").capture_pane_number()', expand('<args>'))"
  }
  api.nvim_command(table.concat(command, " "))

  command = {
    "command!",
    "-nargs=0",
    "TmuxClearUserCommand",
    "call luaeval('require(\"tmux\").clear_user_command()', expand('<args>'))"
  }
  api.nvim_command(table.concat(command, " "))

  command = {
    "command!",
    "-nargs=0",
    "TmuxClearPaneNumber",
    "call luaeval('require(\"tmux\").clear_pane_number()', expand('<args>'))"
  }
  api.nvim_command(table.concat(command, " "))

  -- Create mappings
  for k, v in pairs(M.mappings) do
    util.create_keymap("n", k, v, nresil)
  end
end

-- export locals for test
if _TEST then
  -- setup test alias for private elements using a modified name
  M._get_pane_number = get_pane_number
  M._capture_user_command = capture_user_command
  M._get_user_command = get_user_command
end

return M
