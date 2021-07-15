local common = require('config.plugins.nvim-lspconfig.common')

-- GO111MODULE=on go get golang.org/x/tools/gopls@latest
require'lspconfig'.gopls.setup{
  on_attach = common.on_attach,
  capabilities = common.compeSnippetCapabilities(),
  init_options = {
    codelenses = {
      -- no mappings here atm
      generate = true,
      test = true
    }
  },
}
