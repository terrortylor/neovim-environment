-- Makes a call out to search engine, taking either cWORD in normal mode
-- or visual selection in visual mode.
--
-- vim.keymap.set("n", "gt", search)
-- vim.keymap.set("x", "gt", search)
--
-- Particuarly helpful to search or documentation ;)
local M = {}

function M.search()
  -- TODO URL Encode text?
  local text
  local motion = vim.fn.mode()
  if motion == "v" then
    vim.cmd([[execute "normal! \<esc>"]])
    local starting = vim.api.nvim_buf_get_mark(0, "<")
    local ending = vim.api.nvim_buf_get_mark(0, ">")
    text = vim.api.nvim_buf_get_text(0, starting[1] - 1, starting[2], ending[1] - 1, ending[2] + 1, {})[1]
  elseif motion == "n" then
    text = vim.fn.expand("<cWORD>")
  else
    return
  end

  text = text:gsub("^['\"]", ""):gsub('["]$', "")
  vim.fn.jobstart({ "xdg-open", "https://www.google.com/search?btnL=Search&q=" .. text })
end

return M
