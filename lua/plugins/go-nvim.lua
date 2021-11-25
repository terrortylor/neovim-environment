local M = {}

function M.setup()
  require('go').setup({
    goimport = "gopls",
    lsp_cfg = false,
  })

  require('util.config').create_autogroups({
    format_go_on_save = {
      -- auto format on write, don't do this if the auto_update plugin in enabled
      {"BufWritePre", "*.go", ":silent! lua if not vim.g.enable_auto_update then require('go.format').goimport() end"}
    },
  })
end

return M
