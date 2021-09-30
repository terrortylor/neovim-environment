local M = {}

function M.setup()
  require('go').setup({
    goimport = "gopls",
    lsp_cfg = false,
  })

  require('util.config').create_autogroups({
    format_go_on_save = {
      {"BufWritePre", "*.go", ":silent! lua require('go.format').goimport()"}
    },
  })
end

return M
