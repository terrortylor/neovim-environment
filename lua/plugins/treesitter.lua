return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    -- cmd = { "TSUpdateSync", "TSUpdate", "TSInstall", "TSEnable" },
    config = function () 
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        ensure_installed = {
          "bash",
          "gitcommit",
          "gitconfig",
          "gitignore",
          "go",
          "helm",
          "html",
          "java",
          "javascript",
          "json",
          "kotlin",
          "lua",
          "markdown",
          "markdown_inline",
          "ruby",
          "terraform",
          "typescript",
          "tsx",
          "vimdoc",
          -- "yaml",
        },
        highlight = {
          enable = {},
        },
        query_linter = {
          enable = true,
          use_virtual_text = true,
          lint_events = { "BufWrite", "CursorHold" },
        },
      })
    end
  },

  {
    "RRethy/nvim-treesitter-textsubjects",
    requires = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-treesitter.configs").setup({
        textsubjects = {
          enable = true,
          prev_selection = ',', -- (Optional) keymap to select the previous selection
          keymaps = {
            ['.'] = 'textsubjects-smart',
            [';'] = 'textsubjects-container-outer',
            ['i;'] = { 'textsubjects-container-inner', desc = "Select inside containers (classes, functions, etc.)" },
          },
        },
      })
    end,
  },
}
