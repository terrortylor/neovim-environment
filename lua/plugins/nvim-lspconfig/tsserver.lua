local common = require('plugins.nvim-lspconfig.common')

require'lspconfig'.tsserver.setup{
  on_attach = common.on_attach,
  capabilities = common.compeSnippetCapabilities(),
}
