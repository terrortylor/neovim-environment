local M = {}

function M.rename()
  local cword = vim.fn.expand("<cWORD>")
  os.execute('xdg-open https://www.google.com/search?q=' .. cword)
end

return M
