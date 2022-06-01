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

  require("nvim-tree").setup({
    actions = {
      open_file = {
        quit_on_open = true,
        window_picker = {
          -- TODO reenable if ever vsplit_no_picker option exists
          enable = false,
          -- chars = "asdfjkl;",
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
    renderer = {
      highlight_git = true,
      icons = {
        show = {
          git = false,
          folder_arrow = false,
          file = false,
        },
        glyphs = {
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

  vim.keymap.set("n", "<c-n>", "<cmd>NvimTreeFindFileToggle<CR>", { noremap = true })
end

return M
