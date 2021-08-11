--- Tmux module to handle running commands in a series of panes. Instances map
-- to panes, are if no instance id is provided then it defaults to '1'.
-- Commnds sent in eac instance as kept in a list, used as a stack for historic
-- purposes and selection later. If no instance command found then readline's CTRL-P
-- is sent to the last command is used by default.
-- First time any command against an instance is run the user is prompted for a pane
-- number, the tmux pane numbers pop up, note that user input is captured after numbers
-- disappear.
--
-- To override Command names or key mappings override the following before calling
-- setup():
-- * commands - Change command names
-- * mappings - Change default mappings
--
-- The following actions are available:
-- * TmuxSendCommand - Sends command to pane, if no command has been set then run's last
--                     in pane
-- * TmuxSetCommand - Prompts user to enter command
-- * TmuxEditCommand - Prompts user to enter command, populated with last user set command
-- * TmuxSendCommandOneShot - Prompts user to command to send to pane, does not
--                            keep record of command
--
-- The following are yet to be done:
-- * view instance commands in popup window for selection
-- * ability to get last command from pane and edit

-- TODO Some extension ideas:
-- Sanity check there is more than one pane to send too, if only two select other automatically?
-- change instance pane command

local M = {}

local commands = {
  TmuxSendCommand        = "send_command_to_pane",
  TmuxSetCommand         = "set_instance_command",
  TmuxSendCommandOneShot = "send_one_off_command",
  TmuxEditCommand        = "edit_last_command"
}

-- Define settings
M.mappings = {
  ["<C-PAGEUP>"]   = ":lua require('tmux.commands').scroll(true)<CR>",
  ["<C-PAGEDOWN>"] = ":lua require('tmux.commands').scroll(false)<CR>",
  ["<leader>nn"]   = ":TmuxSendCommand<CR>",
}

-- Create commands and setup mappings
function M.setup()
  for k,v in pairs(commands) do
    local command = {
      "command!",
      "-nargs=?",
      k,
      "lua require('tmux.commands')." .. v .. "(<f-args>)"
    }
    vim.cmd(table.concat(command, " "))
  end

  vim.cmd [[command! -nargs=+ TmuxSeedPane lua require('tmux.commands').seed_instance_pane(<f-args>)]]
  vim.cmd [[command! -nargs=+ TmuxSeedCommand lua require('tmux.commands').seed_instance_command(<f-args>)]]

  local opts = {noremap = true, silent = true}
  local function keymap(...) vim.api.nvim_set_keymap(...) end

  -- Create mappings
  for k, v in pairs(M.mappings) do
    keymap("n", k, v, opts)
  end
end

return M
