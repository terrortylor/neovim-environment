local M = {}

-- Opens nvim if closed, finding current buffer
-- If nvim open and current window then close
-- If nvim open and not current window then find current but and jump too
function M.toggle_nvim()
  local tree = require("nvim-tree")
  local view = require("nvim-tree.view")
  if view.win_open() then
    if view.get_winnr() == vim.api.nvim_get_current_win() then
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
    git = 0,
    folders = 1,
    files = 0,
    icons = 0,
  }

  vim.g.nvim_tree_icons = {
    default = " ",
    folder = {
      default = "ᐅ",
      open = "ᐁ",
      empty = "ᐅ",
      empty_open = "ᐅ",
      symlink = "ᐅ",
    },
    git = {
      unstaged = "~",
      staged = "✓",
      unmerged = "M",
      renamed = "R",
      untracked = "★",
      deleted = "✗",
      ignored = "🙅",
    },
  }
  vim.g.nvim_tree_git_hl = 1
  require("nvim-tree").setup({
    actions = {
      open_file = {
        quit_on_open = true,
        window_picker = {
          chars = "asdfjkl;",
        },
      },
    },
    view = {
      mappings = {
        list = {
          { key = { "o" }, action = "edit", mode = "n" },
          { key = { "<CR>", "<2-LeftMouse>" }, action = "edit_no_picker", mode = "n" },
        },
      },
    },
    diagnostics = {
      enable = true,
      icons = {
        hint = "",
        info = "",
        warning = "",
        error = "E",
      },
    },
    git = {
      ignore = false,
    },
  })

  vim.api.nvim_set_keymap("n", "<c-n>", "<cmd>NvimTreeFindFileToggle<CR>", { noremap = true })
end

return M
