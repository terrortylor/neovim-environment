local c = require("config.colours").c
local hl = require("util.highlights")
local set_highlight = hl.set_highlight
local fg = hl.guifg
local bg = hl.guibg
local util = require("util.config")

local M = {}

function M.setup()
	util.create_autogroups({
		colour_overrides = {
			{ "ColorScheme", "*", "lua require('config.colour-overrides').highlighting()" },
		},
	})
end

function M.highlighting()
	-- Vertical window edge
	set_highlight("VertSplit", fg(c.purple))
	set_highlight("LineNr", fg(c.yellow2))
	set_highlight("EndOfBuffer", fg(c.bg))

	-- Quickfix
	-- Be nice to have a way of changing the selected line, think it defaults to Search hlgroup though
	set_highlight("qfFileName", fg(c.green2))
	set_highlight("qfSeparator", fg(c.yellow2))
	set_highlight("qfLineNr", fg(c.green3))
	set_highlight("qfError", fg(c.blue2))

	-- Search
	set_highlight("Search", { fg(c.bg), bg(c.green1) })
end

return M
