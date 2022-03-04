local M = {}

function M.attach(bufnr)
  print("in atach")

	local cfg = {
		bind = true,
		handler_opts = {
			border = "rounded",
		},
	}

	require("lsp_signature").on_attach({cfg, bufnr})
end

return M
