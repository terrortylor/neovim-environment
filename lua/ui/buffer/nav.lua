local api = vim.api

local M = {}

function M.find_next(direction, search_value)
	local search_term = api.nvim_command_output("echo @/")
	vim.cmd(string.format('execute "normal %s%s\\<CR>"', direction, search_value))

	vim.cmd(string.format('let @/ = "%s"', search_term))
end

return M
