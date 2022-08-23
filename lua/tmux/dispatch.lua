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

-- Used to scroll a pane up/down
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

return M
