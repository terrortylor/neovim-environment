local common = require("plugins.lsp.common")

local luadev = require("lua-dev").setup({
  -- add any options here, or leave empty to use the default settings
  lspconfig = {
    on_attach = common.on_attach,
    capabilities = common.buildCapabilities(),
  },
})

local lspconfig = require("lspconfig")
lspconfig.sumneko_lua.setup(luadev)
