local plug = require("pluginman")

plug.add({
  url = "christoomey/vim-tmux-navigator",
  post_handler = function()
	vim.g.tmux_navigator_no_mappings = 1
	vim.g.tmux_navigator_disable_when_zoomed = 1
	vim.g.tmux_navigator_save_on_switch = 2

    local nav_maps = {
      ["<c-h>"] = ":TmuxNavigateLeft<CR>",
      ["<c-j>"] = ":TmuxNavigateDown<CR>",
      ["<c-k>"] = ":TmuxNavigateUp<CR>",
      ["<c-l>"] = ":TmuxNavigateRight<CR>",
    }

    local opts = {noremap = true, silent = true}
    local function keymap(...) vim.api.nvim_set_keymap(...) end

    for k, v in pairs(nav_maps) do
      keymap("n", k, v, opts)
    end
  end
})
