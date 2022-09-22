local M = {}

--- Executes command in the supplied pane
-- Escapes tmux's normal mode by default
-- @param pane string: pane to send command too
-- @param command string: command to send
-- @param escape boolean: if tmux's normal mode should be escapes, defaults to true
function M.execute(pane, command, escape)
  if vim.opt.autowrite:get() or vim.opt.autowriteall:get() then
    vim.cmd("silent! wall")
  end

  if escape == nil then
    escape = true
  end

  if escape then
    -- if not in normal mode go back to it
    os.execute('tmux if-shell -F -t "' .. pane .. '" "#{pane_in_mode}" "send-keys Escape" ""')
  end
  -- run command
  os.execute('tmux send-keys -t "' .. pane .. '" C-z ' .. string.format("%q", command) .. ' Enter')
end

--- Used to scroll a pane up/down
-- @param pane string: pane to control
-- @param up boolean: should scroll up if true, down if false
function M.scroll(pane, up)
  -- ensure in copy-mode
  os.execute('tmux if-shell -F -t "' .. pane .. '" "#{pane_in_mode}" "" "copy-mode"')
  -- run scroll command
  local direction = "halfpage-down"
  if up then
    direction = "halfpage-up"
  end
  os.execute('tmux send-keys -t "' .. pane .. '" -X ' .. direction)
end

--- Run tmux list-panes
function M.tmux_list_panes()
  local result = vim.fn.system("tmux list-panes")
  local lines = {}
  for s in result:gmatch("[^\r\n]+") do
    table.insert(lines, s)
  end
  return lines
end


--- Gets the number of tmux panes open in current window
function M.get_number_tmux_panes()
  return #M.tmux_list_panes()
end

--- Gets the number of the active tmux panes open in current window
function M.get_active_tmux_panes()
  local lines = M.tmux_list_panes()
  for i,v in pairs(lines) do
    if v:find("%(active%)$") then
      return i
    end
  end
  return 0
end

return M

