local common = require('plugins.lsp.common')

require('util.health').register_required_binary("gopls", "Reqiured for LSP config")

-- GO111MODULE=on go get golang.org/x/tools/gopls@latest
require'lspconfig'.gopls.setup{
  on_attach = common.on_attach,
  capabilities = common.buildCapabilities(),
  init_options = {
    analyses = {unusedparams = true, unreachable = false},
    codelenses = {
      generate = true, -- show the `go generate` lens.
      test = true,
      tidy = true
    },
  }
}
