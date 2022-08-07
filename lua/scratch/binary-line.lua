-- This is messing around based, but someone asked about a binary search line search tool
-- so this is me playing with the idea.
local M = {}

local left, right

function M.setStart()
  local pos = vim.fn.getcurpos()
  local line_nr = pos[2]
  local line = vim.api.nvim_buf_get_lines(0, line_nr - 1, line_nr, false)[1]
  local new_cur_pos = (#line + 1) / 2
  local cur_pos = math.floor(new_cur_pos + 0.5)
  vim.fn.setpos(".", { 0, line_nr, cur_pos, 0 })
  left = 0
  right = #line
end

function M.search(direction)
  local pos = vim.fn.getcurpos()
  local line_nr = pos[2]
  local cur_pos = pos[3]

  local new_pos
  if direction == "forward" then
    local delta = right - cur_pos
    local half_delta = delta / 2
    new_pos = cur_pos + half_delta
    new_pos = math.floor(new_pos + 0.5)
    vim.fn.setpos(".", { 0, line_nr, new_pos, 0 })
    left = cur_pos
  else
    local delta = cur_pos - left
    local half_delta = delta / 2
    new_pos = cur_pos - half_delta
    new_pos = math.floor(new_pos + 0.5)
    vim.fn.setpos(".", { 0, line_nr, new_pos, 0 })
    right = cur_pos
  end
end

-- vim.keymap.set("n", "<leader>nn", function ()
--   M.search("forward")
-- end, {})

-- vim.keymap.set("n", "<leader>mm", function ()
--   M.search("backward")
-- end, {})

return M
