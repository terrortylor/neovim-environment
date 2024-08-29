return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    opts = {
      -- This seems to cause slow start up
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
        "ruby",
        "terraform",
        "typescript",
        "tsx",
        "vimdoc",
        "yaml",
      },
      highlight = {
        enable = true,
      },
      query_linter = {
        enable = true,
        use_virtual_text = true,
        lint_events = { "BufWrite", "CursorHold" },
      },
    },
  },


  {
    "RRethy/nvim-treesitter-textsubjects",
    requires = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-treesitter.configs").setup({
        textsubjects = {
          enable = true,
          keymaps = {
            ["."] = "textsubjects-smart",
            [";"] = "textsubjects-container-outer",
          },
        },
      })
    end,
  },

  {
    "cshuaimin/ssr.nvim",
    keys = {
      { "<leader>sr", function() require("ssr").open() end, mode = "n", },
      { "<leader>sr", function() require("ssr").open() end, mode = "x", },
    },
  },
}
