-- Experimental...
-- Begin to map some IntelliJ keyboard shortcuts as having to use it on a project
local log = require("util.log")

local mappings = {
	n = {
		-- Vim sees <c-/> as <c-_>
		["<c-_>"] = "<CMD>CommentToggle<CR>",
	},
	v = {
		["<c-_>"] = ":<c-u>call CommentOperator(visualmode())<cr>",
	},
	i = {},
	x = {},
	t = {},
}

local opts = { noremap = true, silent = true }
local function keymap(...)
	vim.api.nvim_set_keymap(...)
end

-- Silent maps
for mode, maps in pairs(mappings) do
	for k, v in pairs(maps) do
		if type(v) == "string" then
			keymap(mode, k, v, opts)
		elseif type(v) == "table" then
			if #v == 2 then
				keymap(mode, k, v[1], v[2])
			else
				log.error("Mapping not run for lhs: " .. k .. " mode: " .. mode)
			end
		end
	end
end
