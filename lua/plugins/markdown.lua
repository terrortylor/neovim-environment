return {

  {
    "OXY2DEV/markview.nvim",
    lazy = false,

    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },

    config = function()
      local markview = require("markview")
      local presets = require("markview.presets")

      markview.setup({
        headings = presets.headings.glow_labels,
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
