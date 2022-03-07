require("neorg").setup({
  load = {
    ["core.defaults"] = {}, -- Load all the default modules
    ["core.keybinds"] = { -- Configure core.keybinds
      config = {
        neorg_leader = "<Leader>o", -- This is the default if unspecified
        hook = function(keybinds)
          -- luacheck: ignore
          keybinds.remap_event(
            "core.integrations.telescope.insert_file_link",
            "i",
            "<c-f>",
            "core.integrations.telescope.insert_file_link"
          )
        end,
      },
    },
    ["core.norg.concealer"] = {
      config = {
        icons = {
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
          my_workspace = "~/personnal-workspace/notes",
          gtd_wksp = "~/personnal-workspace/notes/gtd",
          journal = "~/personnal-workspace/notes/journal",
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
    ["core.norg.journal"] = {},
  },
})

vim.api.nvim_add_user_command("GtdCapture", function(_)
  require("neorg").org_file_entered(true, "silent=true")
  vim.cmd("Neorg gtd capture")
end, { force = true })
vim.api.nvim_set_keymap("n", "<leader>otc", "<CMD>GtdCapture<CR>", { noremap = true })

vim.api.nvim_add_user_command("GtdView", function(_)
  require("neorg").org_file_entered(true, "silent=true")
  vim.cmd("Neorg gtd views")
end, { force = true })
vim.api.nvim_set_keymap("n", "<leader>otv", "<CMD>GtdView<CR>", { noremap = true })
