local common = require("plugins.lsp.common")

require("lspconfig").tsserver.setup({
  on_attach = common.on_attach,
  capabilities = common.buildCapabilities(),
})
