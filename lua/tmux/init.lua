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
-- select fenced code block and send somewhere... perhaps even a pane from another window, like a one off shot

  local commands = require("tmux.commands")
  local dispatch = require("tmux.dispatch")
local M = {}

-- Define settings
M.mappings = {
  ["<C-PAGEUP>"] = ":lua require('tmux').scroll(true, 'default')<CR>",
  ["<C-PAGEDOWN>"] = ":lua require('tmux').scroll(false, 'default')<CR>",
  ["<leader>nn"] = ":TmuxDefault<CR>",
}

function M.scroll(up, instance)
  instance = instance or "default"

  local pane, _ = commands.get_pane_and_command(instance)
  if not pane then
    vim.notify("Pane not set", vim.log.levels.ERROR)
    return
  end

  dispatch.scroll(pane, up)
end

function M.do_default()
  local last_command = "^P"
  local identifier = "default"
  local pane, _ = commands.get_pane_and_command(identifier)
  if not pane then
    local panes = dispatch.get_number_tmux_panes()
    if panes < 2 then
      vim.notify("Only single pane found, can't send command anywhere", vim.log.levels.ERROR)
      return
    end
    local pane
    if panes > 2 then
      pane = require("tmux.input").get_pane()
    else
      local cur_pane = dispatch.get_active_tmux_panes()
      if cur_pane == 1 then
        pane = 2
      else
        pane = 1
      end
    end
    commands.add_complete_command(identifier, pane, last_command)
  end
  M.send_command(identifier)
end

function M.seed_command(identifier, pane, command)
  if not identifier then
    vim.notify("Identifier is required", vim.log.levels.ERROR)
    return
  end
  if not pane then
    vim.notify("Pane is required", vim.log.levels.ERROR)
    return
  end
  if not command then
    vim.notify("Command is required", vim.log.levels.ERROR)
    return
  end

  commands.add_complete_command(identifier, pane, command)
end

function M.send_command(identifier)
  local pane, command = commands.get_pane_and_command(identifier)
  print("pane", pane, "command", command)
  if not pane then
    vim.notify("No pane/command found for identifier: " .. identifier, vim.log.levels.ERROR)
    return
  end


  -- check pane exists to throw command somewhere
  local panes = dispatch.get_number_tmux_panes()
  if panes < 2 then
    vim.notify("Only single pane found, can't send command anywhere", vim.log.levels.ERROR)
    return
  end

  if pane > panes then
    vim.notify("Looks like pane doesn't exists anymore", vim.log.levels.ERROR)
    return
  end

  dispatch.execute(pane, command)
end

-- Create commands and setup mappings
function M.setup()
  local opts = { noremap = true, silent = true }
  local function keymap(...)
    vim.api.nvim_set_keymap(...)
  end

  -- Create mappings
  for k, v in pairs(M.mappings) do
    keymap("n", k, v, opts)
  end

  local cmd = vim.api.nvim_create_user_command
  cmd("TmuxSendCommand", function(params)
    local identifier = params.fargs[1]
    M.send_command(identifier)
  end, { nargs = 1 })
  cmd("TmuxSeedCommand", function(params)
    local identifier = params.fargs[1]
    local pane = params.fargs[2]
    local str_com = ""
    for key, value in pairs(params.fargs) do
      -- skip first two args
      if key > 2 then
        if key == 3 then
          str_com = value
        else
          str_com = str_com .. " " .. value
        end
      end
    end
    M.seed_command(identifier, pane, str_com)
  end, { nargs = "+" })
  cmd("TmuxDefault", function(_)
    M.do_default()
  end, {})
end

return M
