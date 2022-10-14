local common = require("plugins.lsp.common")
require("neodev")

local lspconfig = require("lspconfig")
lspconfig.sumneko_lua.setup({
  -- add any options here, or leave empty to use the default settings
  lspconfig = {
    on_attach = common.on_attach,
    capabilities = common.buildCapabilities(),
  },
  Lua = {
    completion = {
      callSnippet = "Replace"
    }
  }
})
