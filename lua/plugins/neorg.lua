require("neorg").setup({
  load = {
    ["core.defaults"] = {}, -- Load all the default modules
    ["core.norg.qol.toc"] = {}, -- table of contents module
    ["core.keybinds"] = { -- Configure core.keybinds
      config = {
        neorg_leader = "<Leader>o", -- This is the default if unspecified
        hook = function(keybinds)
          -- luacheck: ignore
          keybinds.remap_event( "norg", "i",
            "<c-f>",
            "core.integrations.telescope.insert_file_link"
          )
          keybinds.remap_event( "norg", "i",
            "<c-l>",
            "core.integrations.telescope.insert_link"
          )
        end,
      },
    },
    ["core.export"] = { config = { extensions = "all" } },
    ["core.norg.concealer"] = {
      config = {
        icons = {
          marker = {
            icon = "|",
          },
          todo = {
            undone = { icon = " " },
            pending = { icon = "P" },
            done = { icon = "X" },
            hold = { icon = "H" },
            cancelled = { icon = "C" },
          },
        },
      },
    }, -- Allows for use of icons
    ["core.norg.dirman"] = { -- Manage your directories with Neorg
      config = {
        workspaces = {
          my_workspace = "~/personal-workspace/notes",
          gtd_wksp = "~/personal-workspace/notes/gtd",
          journal = "~/personal-workspace/notes/journal",
        },
      },
    },
    ["core.norg.completion"] = {
      config = {
        engine = "nvim-cmp",
      },
    },
    ["core.gtd.base"] = {
      config = {
        workspace = "gtd_wksp",
      },
    },
    ["core.integrations.telescope"] = {},
  },
})

vim.api.nvim_create_user_command("GtdCapture", function(_)
  require("neorg.modules.core.gtd.ui.capture_popup").public.show_capture_popup()
end, { force = true })
vim.api.nvim_set_keymap("n", "<leader>otc", "<CMD>GtdCapture<CR>", { noremap = true })

vim.api.nvim_create_user_command("GtdView", function(_)
  vim.cmd("Neorg gtd views")
end, { force = true })
vim.api.nvim_set_keymap("n", "<leader>otv", "<CMD>GtdView<CR>", { noremap = true })
