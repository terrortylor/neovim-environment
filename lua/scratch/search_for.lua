local M = {}

function M.rename()
  local cword = vim.fn.expand("<cWORD>")
  -- TODO replace spaces iwth + and make web safe
  os.execute('xdg-open https://www.google.com/search?q=' .. cword)
end

return M
