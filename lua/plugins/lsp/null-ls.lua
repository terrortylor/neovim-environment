local null_ls = require("null-ls")
local common = require("plugins.lsp.common")
local register_required_binary = require("util.health").register_required_binary

register_required_binary("stylua", "Used for null-ls formatting of lua files")
register_required_binary("actionlint", "Used by null-l for linting git hub actions")

null_ls.setup({
	on_attach = common.on_attach,
	debug = true,
	sources = {
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.diagnostics.luacheck,

		-- TODO setup eslint here and get rid of efm
		-- null_ls.builtins.diagnostics.eslint,

		null_ls.builtins.diagnostics.actionlint.with({
			filetypes = { "yaml", "yml" },
			condition = function(utils)
				return utils.root_has_file({ ".github" })
			end,
		}),
	},
})
