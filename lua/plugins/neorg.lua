return {
  {
    "nvim-neorg/neorg",
    build = ":Neorg sync-parsers",
    ft = "norg",
    opts = {
      load = {
        ["core.defaults"] = {}, -- Load all the default modules
        ["core.norg.qol.toc"] = {}, -- table of contents module
        ["core.keybinds"] = { -- Configure core.keybinds
          config = {
            neorg_leader = "<Leader>o", -- This is the default if unspecified
            hook = function(keybinds)
              -- luacheck: ignore
              keybinds.remap_event("norg", "i", "<c-f>", "core.integrations.telescope.insert_file_link")
              keybinds.remap_event("norg", "i", "<c-l>", "core.integrations.telescope.insert_link")
              keybinds.unmap("norg", "n", "<,")
              keybinds.unmap("norg", "n", ">.")
              keybinds.remap_event("norg", "n", ">", "core.promo.promote")
              keybinds.remap_event("norg", "n", "<", "core.promo.demote")
            end,
          },
        },
        ["core.export"] = { config = { extensions = "all" } },
        ["core.promo"] = {},
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
            },
          },
        },
        ["core.norg.completion"] = {
          config = {
            engine = "nvim-cmp",
          },
        },
        ["core.integrations.telescope"] = {},
        ["core.integrations.nvim-cmp"] = {},
      },
    },
    depencencies = { "nvim-neorg/neorg-telescope" },
    -- depencencies = { "~/personal-workspace/nvim-plugins/neorg-telescope" },
  },
  { "nvim-neorg/neorg-telescope" },
}
