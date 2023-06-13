return {
  {
    "nvim-neorg/neorg",
    build = ":Neorg sync-parsers",
    depencencies = {
      "nvim-neorg/neorg-telescope",
      "nvim-treesitter/nvim-treesitter-textobjects",
      { "pysan3/neorg-templates", dependencies = { "L3MON4D3/LuaSnip" } },
    },
    keys = {
      { "<c-g>nw", "<cmd>Neorg workspace<cr>", desc = "Neorg Workspace" },
      { "<c-g>nn", "<cmd>Neorg keybind<cr>", desc = "Neorg New Note" },
      { "<c-g>nr", "<cmd>Neorg return<cr>", desc = "Neorg Close & return" },
    },
    -- depencencies = { "~/personal-workspace/nvim-plugins/neorg-telescope" },
    event = "BufReadPre,BufNew *.norg",
    opts = {
      load = {
        ["core.completion"] = {
          config = {
            engine = "nvim-cmp",
            name = "[Norg]",
          },
        },
        ["core.concealer"] = {
          config = {
            icons = {
              todo = {
                undone = { icon = " " },
              },
            },
          },
        },
        ["core.defaults"] = {},
        ["core.dirman"] = {
          config = {
            workspaces = {
              notes = "~/personal-workspace/notes",
            },
            default_workspace = "notes",
          },
        },
        ["core.export"] = {},
        ["core.journal"] = {},
        ["core.keybinds"] = {
          config = {
            default_keybinds = true,
            neorg_leader = "<c-g>",
            hook = function(keybinds)
              -- luacheck: ignore
              keybinds.remap_event("norg", "i", "<c-f>", "core.integrations.telescope.insert_file_link")
              keybinds.remap_event("norg", "i", "<c-l>", "core.integrations.telescope.insert_link")
              keybinds.remap("norg", "n", "<space>ohl", "<cmd>Neorg toc qflist<CR>") -- toc / header list
              keybinds.remap_event("norg", "n", "<c-g><c-g>", "core.qol.todo_items.todo.task_cycle") -- toc / header list
            end,
          },
        },
        ["core.qol.toc"] = {
          config = {
            close_after_use = true,
          },
        },
        ["core.syntax"] = {},
        ["core.integrations.telescope"] = {},
        ["core.integrations.treesitter"] = {},
        ["core.integrations.nvim-cmp"] = {},
        ["external.templates"] = {
          config = {
            templates_dir = vim.fn.stdpath("config") .. "/templates/neorg",
          },
        },
      },
    },
  },
  { "nvim-neorg/neorg-telescope" },
  { "pysan3/neorg-templates" },
}
