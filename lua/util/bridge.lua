local M = {}

local function create_mappings(mode, default_opts, lhs, rhs, description, opts)
	opts = vim.tbl_deep_extend("force", default_opts or {}, opts or {})
	if description then
		opts["desc"] = description
	end

	vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
end

---Metatable to generate helper functions
---Creates nmap, nnoremap mappings etc which handle desc as a argument, not options table item
setmetatable(M, {
	__index = function(self, k)
		local mt = getmetatable(self)
		local x = mt[k]
		if x then
			return x
		end

		local mode, nore = k:match("^([nvxiost])(.*)map$")
		if not mode then
			return
		end

		local opts = {}
		if nore == "nore" then
			opts["noremap"] = true
		else
			opts["noremap"] = false
		end

		local func = function(...)
			create_mappings(mode, opts, ...)
		end
		mt[k] = func
		return func
	end,
})

return M
