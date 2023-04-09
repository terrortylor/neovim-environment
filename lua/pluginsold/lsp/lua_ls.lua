local common = require("plugins.lsp.common")
require("neodev")

local lspconfig = require("lspconfig")
lspconfig.lua_ls.setup({
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
