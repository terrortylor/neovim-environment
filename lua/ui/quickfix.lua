local M = {}

-- close all quickfix windows including clist in current tab
function M.close_all()
	local tab = vim.api.nvim_get_current_tabpage()

	for _, w in pairs(vim.fn.getwininfo()) do
		if w.tabnr == tab then
			if w.quickfix == 1 then
				vim.api.nvim_win_close(w.winid, false)
			end
		end
	end
end

function M.open_list()
	if vim.tbl_count(vim.fn.getloclist(vim.api.nvim_win_get_number(0))) > 0 then
		vim.cmd("lopen")
	else
		if vim.tbl_count(vim.fn.getqflist()) > 0 then
			vim.cmd("copen")
		else
			print("All lists are empty")
		end
	end
end

return M
