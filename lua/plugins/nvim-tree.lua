local plug = require("pluginman")
local create_mappings = require("util.config").create_mappings

local M = {}

-- TODO finish this magic off!
function M.toggle_nvim()
  local width = vim.api.nvim_get_option("columns")
  local shift = math.floor(width / 3)
  if shift < 30 then
    shift = 30
  end
  require'nvim-tree.view'.View.width = shift

  -- if open then go to window, else open it
  vim.cmd("NvimTreeToggle")
end

function M.setup()
  -- These need to be set before the plugin in loaded
  vim.g.nvim_tree_show_icons = {
    git = 0,
    folders = 1,
    icons = 0
  }

  vim.g.nvim_tree_icons = {
    folder = {
      default =    "ᐅ",
      open =       "ᐁ",
      empty =      "ᐅ",
      empty_open = "ᐅ",
      symlink =    "ᐅ",
    }
  }
  vim.g.nvim_tree_auto_close = 1
  vim.g.nvim_tree_follow = 1
  vim.g.nvim_tree_quit_on_open = 1
  vim.g.nvim_tree_indent_markers = 1
  vim.g.nvim_tree_disable_window_picker = 1
  -- vim.g.nvim_tree_width_allow_resize = 1

  plug.add({
    url = "kyazdani42/nvim-tree.lua",
    post_handler  = function()
      create_mappings({
        n = {
          ["<c-n>"] = "<cmd>lua require('plugins.nvim-tree').toggle_nvim()<CR>",
        }
      })
    end
  })
end

return M
