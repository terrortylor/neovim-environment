local M = {}

-- auto popup signature help... cheap but could do with better pum support
-- i.e. close sgnature help when pum visible
function M.cheap_signiture()
  if vim.fn.mode() ~= "i" then
    return
  end

  if vim.fn.pumvisible() == 0 then
    vim.lsp.buf.signature_help()
  end
end

function M.cheap_signiture_toggle()
  local toggle = vim.g.cheap_signiture_enabled
  toggle = not toggle
  if toggle then
    require('util.config').create_autogroups({
      lsp_hover = {
        {"CursorMovedI", "*", "lua require('lsp.signature').cheap_signiture()"},
      }})
    else
      vim.cmd("autocmd! lsp_hover")
    end
    vim.g.cheap_signiture_enabled = toggle
  end

function M.setup()
  vim.cmd [[command! -nargs=0 ToggleSignature lua require('lsp.signature').cheap_signiture_toggle()]]
  vim.g.cheap_signiture_enabled = false
  M.cheap_signiture_toggle()
end

return M
