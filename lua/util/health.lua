-- As cofig becomes more and more dependant on external sources
-- this is a helper module to help register and check they are
-- available
-- Exposed as user command set lua/config/commads.lua

local M = {}
local draw = require("ui.window.draw")

M.required_bins = {}

function M.register_required_binary(bin, description)
	if not bin or not description then
		-- luacheck: ignore
		print(
			"can not register required binary, bin and description must be set: bin: "
				.. bin
				.. " description: "
				.. description
		)
		return
	end

	local bin_descs = M.required_bins[bin]
	if bin_descs then
		table.insert(bin_descs, description)
		return
	end

	M.required_bins[bin] = { description }
end

function M.generate_empty_health_table()
	return {
		missing_binaries = {},
	}
end

function M.get_health_table()
	local htbl = M.generate_empty_health_table()

	for key, value in pairs(M.required_bins) do
		if vim.fn.executable(key) == 0 then
			local bin_descs = htbl["missing_binaries"][key]
			if not bin_descs then
				htbl["missing_binaries"][key] = value
			end
		end
	end

	return htbl
end

function M.display()
	-- TODO make this print nicely
	-- TODO make this handle closing buffer?
	local result_buf = vim.api.nvim_create_buf(false, true)

	vim.api.nvim_buf_set_option(result_buf, "filetype", "healthresult")
	vim.api.nvim_buf_set_name(result_buf, "HealthResult")

	local lines = {}
	for s in vim.inspect(M.get_health_table()):gmatch("[^\r\n]+") do
		table.insert(lines, s)
	end
	vim.api.nvim_buf_set_lines(result_buf, 0, vim.api.nvim_buf_line_count(result_buf), false, lines)

	draw.open_draw(result_buf)
end

return M
