local M = {}

M.win = nil

function M.rename()
	local opts = {
		relative = "cursor",
		row = 0,
		col = 0,
		width = 30,
		height = 1,
		style = "minimal",
		border = "rounded",
	}
	local cword = vim.fn.expand("<cword>")
	local buf = vim.api.nvim_create_buf(false, true)
	M.win = vim.api.nvim_open_win(buf, true, opts)

	vim.api.nvim_buf_set_lines(buf, 0, -1, false, { cword })
	local silent = { silent = true }
	-- TODO setup autocommands perhaps to handle these?
	-- vim.api.nvim_buf_set_keymap(buf, 'i', '<CR>', '<cmd>lua require("scratch.lsp_rename_popup").execute()<CR>',silent)
	vim.api.nvim_buf_set_keymap(buf, "n", "<CR>", '<cmd>lua require("scratch.lsp_rename_popup").execute()<CR>', silent)
	vim.api.nvim_buf_set_keymap(buf, "n", "<ESC>", "<cmd>lua vim.api.nvim_win_close(" .. M.win .. ", true)<CR>", silent)
	vim.api.nvim_buf_set_keymap(buf, "n", "q", "<cmd>lua vim.api.nvim_win_close(" .. M.win .. ", true)<CR>", silent)
end

function M.execute()
	local new_name = vim.trim(vim.fn.getline("."))
	vim.api.nvim_win_close(M.win, true)
	vim.lsp.buf.rename(new_name)
end

return M
