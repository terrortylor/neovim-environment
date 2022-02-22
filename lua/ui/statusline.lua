local c = require("config.colours").c
local highlights = require("util.highlights")
local set_highlight = highlights.set_highlight
local fg = highlights.guifg
local bg = highlights.guibg
local util = require("util.config")

local M = {}

local ignore_filetypes = {
	"qf",
	"help",
	"TelescopePrompt",
	"NvimTree",
}

function M.statusline(active)
	local sl = ""

	local active_hl = ""
	if not active then
		active_hl = "NC"
	end

	local add = function(hl, text)
		sl = sl .. "%#" .. hl .. active_hl .. "#" .. text
	end

	local filetype = vim.api.nvim_buf_get_option(0, "filetype")

	for _, ft in pairs(ignore_filetypes) do
		if ft == filetype then
			vim.wo.statusline = sl
			return
		end
	end

	-- TODO must be a nicer way to get buf name relative to CWD
	-- local cwd = vim.fn.getcwd(0, 0)
	-- local buf = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(0))
	-- buf = buf:gsub(vim.pesc(cwd.."/"), "")
	-- add("StatusLineBuffer", buf)

	add("StatusLineBuffer", " %f")
	sl = sl .. "%<"
	-- TODO no highlighting here
	add("StatusLineBufferModified", "%m")
	add("StatusLineBufferReadOnly", "%r")

	-- right hand side
	sl = sl .. "%="

	-- TODO on first load these highlight groups are not suffixed with
	-- NC if not current window
	add("StatusLineBracket", "[")
	add("StatusLinePosition", "%l")
	add("StatusLinePositionSeperator", "/")
	add("StatusLinePosition", "%L %c")
	add("StatusLineBracket", "] ")

	vim.wo.statusline = sl
end

function M.setup()
	util.create_autogroups({
		statusline_update = {
			{ "VimEnter,WinEnter,BufWinEnter", "*", "lua require('ui.statusline').statusline(true)" },
			{ "WinLeave", "*", "lua require('ui.statusline').statusline(false)" },
		},
		statusline_highlights = {
			{ "ColorScheme", "*", "lua require('ui.statusline').highlighting()" },
		},
	})
end

function M.highlighting()
	set_highlight("StatusLine", { fg(c.blue2), bg(c.purple) })
	set_highlight("StatusLineNC", { fg(c.grey1), bg(c.purple) })
	set_highlight("StatusLineBracket", { fg(c.green2), bg(c.purple) })
	set_highlight("StatusLinePosition", { fg(c.blue2), bg(c.purple) })
	set_highlight("StatusLinePositionSeperator", { fg(c.green2), bg(c.purple) })
end

return M
