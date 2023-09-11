return {
  {
    "nvim-neorg/neorg",
    build = ":Neorg sync-parsers",
    depencencies = {
      "nvim-neorg/neorg-telescope",
      "nvim-treesitter/nvim-treesitter-textobjects",
      -- { "pysan3/neorg-templates", dependencies = { "L3MON4D3/LuaSnip" } },
    },
    cmd = {
      "Neorg",
    },
    keys = {
      { "<c-g>nw", "<cmd>Neorg workspace<cr>", desc = "Neorg Workspace" },
      { "<c-g>nn", function() -- create a new slipbox note
        -- TODO popup to offer adding link also to where ever I am?
        require("neorg.modules.core.dirman.module").public.create_file("slipbox/" .. os.date("%Y%m%d%H%M%S"), "notes", {no_open = false, force = false})
        local snips = require("luasnip").get_snippets()[vim.bo.ft]
        for _, snip in ipairs(snips) do
          if snip["name"] == "templateslipbox" then
            require("luasnip").snip_expand(snip)
          end
        end
      end, desc = "Neorg New Slip Note" },
      { "<c-g>nr", "<cmd>Neorg return<cr>", desc = "Neorg Close & return" },
      {
        "<c-g>nd",
        function()
          vim.cmd([[
          Neorg journal yesterday
          topleft vsplit
          Neorg journal today
          Neorg templates fload journal
          ]])
        end,
        desc = "Neorg ",
      },
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
        ["core.itero"] = {},
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
              keybinds.unmap("norg", "n", "<c-g>nn")
            end,
          },
        },
        ["core.promo"] = {},
        ["core.qol.toc"] = {
          config = {
            close_after_use = true,
          },
        },
        ["core.syntax"] = {},
        ["core.upgrade"] = {},
        ["core.integrations.telescope"] = {},
        ["core.integrations.treesitter"] = {},
        ["core.integrations.nvim-cmp"] = {},
      },
    },
  },
  { "nvim-neorg/neorg-telescope" },
}
