local common = require('config.plugins.nvim-lspconfig.common')

require'lspconfig'.tsserver.setup{
  on_attach = common.on_attach,
  capabilities = common.compeSnippetCapabilities(),
}
