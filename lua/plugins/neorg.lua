require("neorg").setup({
  load = {
    ["core.defaults"] = {}, -- Load all the default modules
    ["core.keybinds"] = { -- Configure core.keybinds
      config = {
        neorg_leader = "<Leader>o", -- This is the default if unspecified
        -- hook = function(keybinds)
        --   -- luacheck: ignore
        --   keybinds.remap_event(
        --     "core.integrations.telescope.insert_file_link",
        --     "i",
        --     "<c-f>",
        --     "core.integrations.telescope.insert_file_link"
        --   )
        -- end,
      },
    },
    ["core.norg.concealer"] = {
      config = {
        icons = {
          marker ={
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
    ["core.norg.journal"] = {},
  },
})

local neorg_callbacks = require("neorg.callbacks")

neorg_callbacks.on_event("core.keybinds.events.enable_keybinds", function(_, keybinds)
    -- Map all the below keybinds only when the "norg" mode is active
    keybinds.map_event_to_mode("norg", {
      i = {
        { "<C-l>", "core.integrations.telescope.insert_link" },
        { "<C-f>", "core.integrations.telescope.insert_file_link" },
      },
    }, {
        silent = true,
        noremap = true,
    })
end)

vim.api.nvim_create_user_command("GtdCapture", function(_)
  require("neorg").org_file_entered(true, "silent=true")
  vim.cmd("Neorg gtd capture")
end, { force = true })
vim.api.nvim_set_keymap("n", "<leader>otc", "<CMD>GtdCapture<CR>", { noremap = true })

vim.api.nvim_create_user_command("GtdView", function(_)
  require("neorg").org_file_entered(true, "silent=true")
  vim.cmd("Neorg gtd views")
end, { force = true })
vim.api.nvim_set_keymap("n", "<leader>otv", "<CMD>GtdView<CR>", { noremap = true })
