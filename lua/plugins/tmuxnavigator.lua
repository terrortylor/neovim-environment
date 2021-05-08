local plug = require("pluginman")
local util = require("util.config")

plug.add({
  url = "christoomey/vim-tmux-navigator",
  post_handler = function()
    local global_variables = {
      tmux_navigator_no_mappings         = 1,
      tmux_navigator_disable_when_zoomed = 1,
      tmux_navigator_save_on_switch      = 2,
    }

    util.set_variables(global_variables)

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
