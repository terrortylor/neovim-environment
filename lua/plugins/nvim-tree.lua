local M = {}

-- Opens nvim if closed, finding current buffer
-- If nvim open and current window then close
-- If nvim open and not current window then find current but and jump too
function M.toggle_nvim()
  local tree = require("nvim-tree")
  local view = require("nvim-tree.view")
  if view.win_open() then
    if  view.get_winnr() == vim.api.nvim_get_current_win() then
      view.close()
      return
    end
  else
    -- TODO have a max windth perhaps?
    local width = vim.api.nvim_get_option("columns")
    local shift = math.floor(width / 3)
    if shift < 30 then
      shift = 30
    end
    view.width = shift
  end
  tree.find_file(true)
end

function M.setup()
  vim.g.nvim_tree_show_icons = {
    git = 1,
    folders = 1,
    files = 0,
    icons = 0,
  }

  vim.g.nvim_tree_icons = {
    default = " ",
    folder = {
      default =    "ᐅ",
      open =       "ᐁ",
      empty =      "ᐅ",
      empty_open = "ᐅ",
      symlink =    "ᐅ",
    },
    git = {
      unstaged =  "~",
      staged =  "✓",
      unmerged =  "M",
      renamed =  "R",
      untracked =  "★",
      deleted =  "✗",
      ignored =  "I"
    }
  }
  vim.g.nvim_tree_quit_on_open = 1
  vim.g.nvim_tree_indent_markers = 1
  vim.g.nvim_tree_disable_window_picker = 1
  require'nvim-tree'.setup {
    auto_close = true,
    diagnostics = {
      enable = true,
      icons = {
        hint = "",
        info = "",
        warning = "",
        error = "E",
      }
    },
    git = {
      ignore = false,
    }

  }

  local create_mappings = require("util.config").create_mappings

  create_mappings({
    n = {
      ["<c-n>"] = "<cmd>NvimTreeFindFileToggle<CR>",
    }
  })
end

return M
