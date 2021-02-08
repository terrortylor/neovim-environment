local mappings = {
  n = {
    -- Find files
    ["<C-p>"] = ":Files<CR>",
    -- Switch buffers
    ["<leader><space>"]  = ":Buffers<CR>",
  }
}

local opts = {noremap = true, silent = true}
local function keymap(...) vim.api.nvim_set_keymap(...) end

-- Silent maps
for mode, maps in pairs(mappings) do
  for k, v in pairs(maps) do
    keymap(mode, k, v, opts)
  end
end

