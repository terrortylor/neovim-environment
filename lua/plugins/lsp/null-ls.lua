local null_ls = require("null-ls")
local common = require("plugins.lsp.common")
local register_required_binary = require("util.health").register_required_binary

register_required_binary("stylua", "Used for null-ls formatting of lua files")
register_required_binary("actionlint", "Used by null-ls for linting git hub actions")
register_required_binary("shellcheck", "Used by null-ls")
register_required_binary("shfmt", "Used by null-ls")

null_ls.setup({
  on_attach = common.on_attach,
  debug = true,
  sources = {
    -- lua
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.diagnostics.luacheck,

    -- bash/shell
    null_ls.builtins.code_actions.shellcheck,
    null_ls.builtins.diagnostics.shellcheck,
    null_ls.builtins.formatting.shfmt,

    -- refactoring
    null_ls.builtins.code_actions.refactoring,

    -- TODO setup eslint here and get rid of efm
    -- null_ls.builtins.diagnostics.eslint,

    -- github actions
    null_ls.builtins.diagnostics.actionlint.with({
      filetypes = { "yaml.github" },
    }),
  },
})
