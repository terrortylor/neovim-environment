local actions = require("telescope.actions")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local conf = require("telescope.config").values
local entry_display = require("telescope.pickers.entry_display")
local action_state = require("telescope.actions.state")

local function get_all_available_keymaps(mode)
	mode = { mode } or { "n", "v", "x", "i", "o", "s", "t" }
	local mappings = {}
	-- TODO for some reason this removes some mappings when all modes passed, Lazygit for example
	-- which is a n mapping, isn't present when adding them all
	-- keep works, and error throws error, so there is a conflicting
	-- mapping
	for _, v in pairs(mode) do
		local r = vim.api.nvim_get_keymap(v)
		mappings = vim.tbl_extend("force", mappings, r)
	end

	-- filter out mappings with out modes set
	local filtered = {}
	for _, value in ipairs(mappings) do
		if value.mode ~= " " then
			table.insert(filtered, value)
		end
	end
	mappings = filtered

	-- filter out mappings that aren't anything to do with this buffer
	local bufnr = vim.fn.bufnr("%")
	filtered = {}
	for _, value in ipairs(mappings) do
		if value.buffer == 0 or value.buffer ~= bufnr then
			table.insert(filtered, value)
		end
	end
	return filtered
end

local function search(opts)
	local mode = vim.api.nvim_get_mode().mode
	print("mode", mode)

	local displayer = entry_display.create({
		separator = " ",
		items = {
			{ width = 15 },
			{ width = 3 },
			{ width = 50 },
			{ remaining = true },
		},
	})
	local make_display = function(entry)
		local left = entry.value.mode .. " " .. entry.value.lhs
		local middle
		local right = ""
		if entry.value.desc == "" then
			middle = entry.value.rhs
		else
			middle = entry.value.desc
			right = entry.value.rhs
		end
		return displayer({
			left,
			" | ",
			middle,
			right,
		})
	end

	pickers.new(opts, {
		prompt_title = "key mappings",
		sorter = conf.generic_sorter(opts),
		finder = finders.new_table({
			results = get_all_available_keymaps(mode),
			entry_maker = function(mapping)
				-- ordinal should be description if present
				local ordinal
				if not mapping.desc then
					ordinal = mapping.rhs
				else
					ordinal = mapping.desc
				end

				return {
					value = mapping,
					ordinal = ordinal,
					display = make_display,
				}
			end,
		}),
		attach_mappings = function(prompt_bufnr, _)
			actions.select_default:replace(function()
				actions.close(prompt_bufnr)
				local selection = action_state.get_selected_entry()
				local keys = vim.api.nvim_replace_termcodes(selection.value.lhs, true, false, true)
				-- TODO support other modes!
				if mode == "i" then
					vim.api.nvim_feedkeys("i" .. keys, "m", true)
				else
					vim.api.nvim_feedkeys(keys, "m", true)
				end
			end)
			return true
		end,
	}):find()
end

return require("telescope").register_extension({
	exports = {
		mapdesc = search,
	},
})
