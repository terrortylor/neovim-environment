local api = vim.api
local log = require('util.log')
local buf_util = require('util.buffer')
local M = {}

M.error_modified = "E89: no write since last change"

-- Taken from:
-- https://stackoverflow.com/questions/1444322/how-can-i-close-a-buffer-without-closing-the-window/44950143#44950143
function M.delete_buffer_keep_window()
  if api.nvim_buf_get_option(0, "modified") then
    log.error(M.error_modified)
  else
    local cur_win = api.nvim_get_current_win()
    local buf_to_delete = api.nvim_get_current_buf()

    local windows = vim.api.nvim_list_wins()
    for _,win in pairs(windows) do
      M.change_buffer(win, buf_to_delete)
    end

    api.nvim_set_current_win(cur_win)
    vim.cmd("bdelete " .. buf_to_delete)
  end
end

function M.change_buffer(window, buf_to_delete)
  api.nvim_set_current_win(window)

  if api.nvim_win_get_buf(window) == buf_to_delete then
    local alt_id = buf_util.get_buf_id('#')

    if alt_id > 0 and api.nvim_buf_is_loaded(alt_id) then
      vim.cmd("buffer #")
    else
      vim.cmd("bnext")
      -- bnext can not do anything, so this checks if buffer is still the same
      -- and if so then just create a new buf
      if api.nvim_win_get_buf(window) == buf_to_delete then
        vim.cmd("enew")
      end
    end
  end
end

return M
