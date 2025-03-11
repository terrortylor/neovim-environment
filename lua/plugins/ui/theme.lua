return {
  -- the colorscheme should be available when starting Neovim

  -- {
    --   "folke/tokyonight.nvim",
    --   lazy = false, -- make sure we load this during startup if it is your main colorscheme
    --   priority = 1000, -- make sure to load this before all the other start plugins
    --   config = function()
      --     -- load the colorscheme here
      --     vim.cmd.colorscheme("tokyonight")
      --   end,
      -- },

      { "catppuccin/nvim", name = "catppuccin", priority = 1000,
      lazy = false, -- make sure we load this during startup if it is your main colorscheme
      config = function()
        -- setup integrations
        require("catppuccin").setup({
          integrations = {
            cmp = true,
            overseer = true,
            telescope = {
              enabled = true,
            },
            gitsigns = true,
            nvimtree = true,
            treesitter = true,
            notify = false,
            dashboard = true,
            mason = true,
            noice = true,
          }
        })

        -- load the colorscheme here
        vim.cmd.colorscheme("catppuccin-mocha")
      end,
    }
  }
