local actions = require('telescope.actions')

require('telescope').setup{
  defaults = {
    mappings = {
      i = {
        ["<c-j>"] = actions.move_selection_next,
        ["<c-k>"] = actions.move_selection_previous,
        ["<esc>"] = actions.close
      }
    }
  }
}

local mappings = {
  n = {
    ["<leader>ff"] = "<cmd>lua require('telescope.builtin').find_files()<CR>",
    ["<c-p>"] = "<cmd>lua require('telescope.builtin').git_files()<CR>",
    ["<leader>fg"] = "<cmd>lua require('telescope.builtin').live_grep()<CR>",
    ["<leader><space>"] = "<cmd>lua require('telescope.builtin').buffers()<CR>",
    ["<leader>fh"] = "<cmd>lua require('telescope.builtin').help_tags()<CR>"
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

