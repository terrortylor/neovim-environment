return {

  {
    "OXY2DEV/markview.nvim",
    ft = "markdown",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local markview = require("markview")
      local presets = require("markview.presets")
      markview.setup({
        headings = presets.headings.glow_labels,
        list_items = {
          marker_minus = {
            add_padding = false,
          },
          marker_plus = {
            add_padding = false,
          },
          marker_star = {
            add_padding = false,
          },
          marker_dot = {
            add_padding = false,
          },
        },
        checkboxes = {
          enable = true,
          checked = {
            text = "[✔]",
            hl = "MarkviewCheckboxChecked",
          },
          pending = {
            text = "[◯]",
            hl = "MarkviewCheckboxPending",
          },
          unchecked = {
            text = "[✘]",
            hl = "MarkviewCheckboxUnchecked",
          },
        },
      })
      -- vim.cmd("Markview enableAll")
    end,
  },

  {
    "gaoDean/autolist.nvim",
    ft = {
        "markdown",
        "text",
        "tex",
        "plaintex",
        "norg",
    },
    config = function()
        require("autolist").setup()

        vim.keymap.set("i", "<tab>", "<cmd>AutolistTab<cr>")
        vim.keymap.set("i", "<s-tab>", "<cmd>AutolistShiftTab<cr>")
        -- vim.keymap.set("i", "<c-t>", "<c-t><cmd>AutolistRecalculate<cr>") -- an example of using <c-t> to indent
        vim.keymap.set("i", "<CR>", "<CR><cmd>AutolistNewBullet<cr>")
        vim.keymap.set("n", "o", "o<cmd>AutolistNewBullet<cr>")
        vim.keymap.set("n", "O", "O<cmd>AutolistNewBulletBefore<cr>")
        vim.keymap.set("n", "<CR>", "<cmd>AutolistToggleCheckbox<cr><CR>")
        vim.keymap.set("n", "<C-r>", "<cmd>AutolistRecalculate<cr>")

        -- cycle list types with dot-repeat
        vim.keymap.set("n", "<leader>cn", require("autolist").cycle_next_dr, { expr = true })
        vim.keymap.set("n", "<leader>cp", require("autolist").cycle_prev_dr, { expr = true })

        -- functions to recalculate list on edit
        vim.keymap.set("n", ">>", ">><cmd>AutolistRecalculate<cr>")
        vim.keymap.set("n", "<<", "<<<cmd>AutolistRecalculate<cr>")
        vim.keymap.set("n", "dd", "dd<cmd>AutolistRecalculate<cr>")
        vim.keymap.set("v", "d", "d<cmd>AutolistRecalculate<cr>")
    end,
  },

  -- {
  --   "jakewvincent/mkdnflow.nvim",
  --   config = function()
  --     require("mkdnflow").setup({
  --       -- Config goes here; leave blank for defaults
  --     })
  --   end,
  -- },

  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
}
