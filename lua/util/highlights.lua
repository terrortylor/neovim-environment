local M = {}

function M.set_highlight(hl, style)
  if type(style) == "table" then
    style = table.concat(style, " ")
  end
  -- print(string.format( "highlight %s %s", hl, style))
  vim.api.nvim_exec(string.format("highlight %s %s", hl, style), false)
end

-- TODO use metatable to auto geneate these
function M.guifg(colour)
  return string.format("guifg=%s", colour)
end

function M.guibg(colour)
  return string.format("guibg=%s", colour)
end

return M
