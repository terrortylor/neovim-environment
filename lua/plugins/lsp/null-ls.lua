local common = require('plugins.lsp.common')

require('util.health').register_required_binary("stylua", "Used for null-ls formatting of lua files")

require("null-ls").setup({
  on_attach = common.on_attach,
  sources = {
    require("null-ls").builtins.formatting.stylua,
    -- TODO setup eslint here and get rid of efm
    -- require("null-ls").builtins.diagnostics.eslint,
  },
})
