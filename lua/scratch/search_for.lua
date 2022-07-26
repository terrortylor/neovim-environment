local M = {}

local function search()
  -- TODO URL Encode text?
  local text = ""
  local motion = vim.fn.mode()
  if motion == "v" then

    -- local get_line_pos = function(pos)
    --   return {pos[2], pos[3]}
    -- end
    -- local starting = get_line_pos(vim.fn.getpos("v"))
    -- local ending = get_line_pos(vim.fn.getpos("."))

    vim.cmd([[execute "normal! \<esc>"]])
    local starting = vim.api.nvim_buf_get_mark(0, "<")
    local ending = vim.api.nvim_buf_get_mark(0, ">")

    -- print(vim.inspect(starting))
    -- print(vim.inspect(ending))
    text = vim.api.nvim_buf_get_text(0, starting[1]-1, starting[2], ending[1]-1, ending[2]+1, {})[1]
  elseif motion == "n" then
    text = vim.fn.expand("<cWORD>")
  else
    return
  end
  print('xdg-open https://www.google.com/search?q=' .. text)
  -- os.execute('xdg-open https://www.google.com/search?q=' .. text)
end

vim.keymap.set("n", "gt", search)
vim.keymap.set("x", "gt", search)

