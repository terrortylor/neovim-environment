local M = {}

-- auto popup signature help... cheap but could do with better pum support
-- i.e. close sgnature help when pum visible
function M.cheap_signiture()
	if vim.fn.mode() ~= "i" then
		return
	end

	if vim.fn.pumvisible() == 0 then
		local clients = vim.lsp.buf_get_clients(0)
		for _, client in pairs(clients) do
			if client.resolved_capabilities.signature_help then
				vim.lsp.buf.signature_help()
        return
			end
		end
	end
end

function M.cheap_signiture_toggle()
	local toggle = vim.g.cheap_signiture_enabled
	toggle = not toggle
	if toggle then
		require("util.config").create_autogroups({
			lsp_hover = {
				{ "CursorMovedI", "*", "lua require('lsp.signature').cheap_signiture()" },
			},
		})
	else
		vim.cmd("autocmd! lsp_hover")
	end
	vim.g.cheap_signiture_enabled = toggle
end

function M.setup()
	vim.api.nvim_add_user_command("ToggleSignature", require("lsp.signature").cheap_signiture_toggle, { force = true })
	vim.g.cheap_signiture_enabled = false
	M.cheap_signiture_toggle()
end

return M
