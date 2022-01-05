require('neorg').setup {
  -- Tell Neorg what modules to load
  load = {
    ["core.defaults"] = {}, -- Load all the default modules
    ["core.keybinds"] = { -- Configure core.keybinds
      config = {
        default_keybinds = true, -- Generate the default keybinds
        neorg_leader = "<Leader>o" -- This is the default if unspecified
      }
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
          daybook = "~/personnal-workspace/notes/daybook",
        }
      }
    },
    ["core.norg.completion"] = {
      config = {
        engine = "nvim-cmp"
      }
    },
    ["core.gtd.base"] = {
      config = {
        workspace = "gtd_wksp",
      },
    },
    ["core.integrations.telescope"] = {},
    ["core.norg.journal"] = {
       config = {
         workspace = "daybook"
       }
    }
  },
  hook = function ()
    local neorg_callbacks = require('neorg.callbacks')

    neorg_callbacks.on_event("core.keybinds.events.enable_keybinds", function(_, keybinds)

      -- Map all the below keybinds only when the "norg" mode is active
      keybinds.map_event_to_mode("norg", {
        i = {
          { "<C-a>", "core.integrations.telescope.insert_link" }

        },
      }, {
        silent = true,
        noremap = true
      })

    end)
  end
}
