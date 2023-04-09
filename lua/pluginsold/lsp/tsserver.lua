local common = require("plugins.lsp.common")
require("util.health").register_required_binary ("typescript-language-server", "Used for JS/TSX LSP")

require("lspconfig").tsserver.setup({
  on_attach = common.on_attach,
  capabilities = common.buildCapabilities(),
})
