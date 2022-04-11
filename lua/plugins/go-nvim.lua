local M = {}

function M.setup()
  require("go").setup({
    goimport = "gopls",
    lsp_cfg = false,
  })

  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.go",
    callback = function()
      -- TODO why did I set this? MADNESS?
      if not vim.g.enable_auto_update then
        require("go.format").goimport()
      end
    end,
    group = vim.api.nvim_create_augroup("format_go_on_save", { clear = true }),
  })
end

return M
