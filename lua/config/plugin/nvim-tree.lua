local plug = require("pluginman")
local create_mappings = require("util.config").create_mappings

plug.add({
  url = "kyazdani42/nvim-tree.lua",
  post_handler  = function()

    local mappings = {
      n = {
        ["<c-n>"] = "<cmd>NvimTreeToggle<CR>",
      }
    }

    create_mappings(mappings)

    vim.g.nvim_tree_show_icons = {
      git = 0,
      folders = 0,
      icons = 0
    }
    vim.g.nvim_tree_auto_close = 1
    vim.g.nvim_tree_follow = 1
    vim.g.nvim_tree_quit_on_open = 1
    vim.g.nvim_tree_indent_markers = 1
  end
})
