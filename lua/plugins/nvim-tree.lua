local M = {}

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
