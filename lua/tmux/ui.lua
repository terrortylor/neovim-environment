local float = require("plenary.window.float")
local panes = require("tmux.commands").instance_pane
local commands = require("tmux.instance_command")
local utils = require("util.test_utils")

local NO_PANES_SET_MESSAGE = "TMUX commands are empty"
local EMPTY_PANE_COMMAND_MESSAGE = "Not Set, defaults to last command run"

-- TODO
-- TODO tests
-- TODO delete entry, need to delete instance command and instance pane
-- TODO show instance command history
-- TODO edit command has completeion from history
-- TODO ability to prompt for pane

local set_popup_exit_keymaps = function(bufnr)
  vim.keymap.set("n", "q", ":bd!<CR>", { buffer = bufnr })
  vim.keymap.set("n", "<ESC>", ":bd!<CR>", { buffer = bufnr })
end

local set_instance_command = function(instance)
  local lines = utils.get_buf_lines()
  local line = ""
  for _, value in pairs(lines) do
    line = line .. value
  end
  print("new line: ", line)
  if line == "" or line == EMPTY_PANE_COMMAND_MESSAGE then
    commands.set_instance_command(instance, nil)
    return
  end
  commands.set_instance_command(instance, line)
end

local edit_line = function()
  local line = vim.api.nvim_get_current_line()
  print("Line", line)
  if line == NO_PANES_SET_MESSAGE then
    return
  end

  local res = float.percentage_range_window(0.8, 0.1, {}, {})
  set_popup_exit_keymaps(res.bufnr)
  local instance, pane, command = line:match("^(.+):%sPane:%s(.*)%sCommand:%s(.+)$")
  print("line parts:", instance, pane, command)
  vim.api.nvim_buf_set_lines(res.bufnr, 0, 1, false, { command })
  vim.keymap.set("n", "<cr>", function()
    set_instance_command(instance)
    vim.api.nvim_buf_delete(res.bufnr, {})
  end, { buffer = res.bufnr })
end

local res = float.percentage_range_window(0.5, 0.5, {}, {})
set_popup_exit_keymaps(res.bufnr)
vim.keymap.set("n", "<cr>", edit_line, { buffer = res.bufnr })

local lines = {}
if vim.tbl_isempty(panes) then
  table.insert(lines, NO_PANES_SET_MESSAGE)
else
  for key, value in pairs(panes) do
    print(key .. ": " .. value)
    local command = commands.get_instance_command(key)
    if not command then
      command = EMPTY_PANE_COMMAND_MESSAGE
    end
    table.insert(lines, key .. ": Pane: " .. value .. " Command: " .. command)
  end
end

vim.api.nvim_buf_set_lines(res.bufnr, 0, 1, false, lines)
