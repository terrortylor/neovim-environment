local common = require("plugins.lsp.common")

require("util.health").register_required_binary("terraform-ls", "Reqiured for terraform LSP config")
-- https://github.com/hashicorp/terraform-ls/blob/main/docs/installation.md

require("lspconfig").terraformls.setup({
	on_attach = common.on_attach,
	capabilities = common.buildCapabilities(),
})

