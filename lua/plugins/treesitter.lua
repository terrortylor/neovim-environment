return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "bash",
        "gitcommit",
        "gitconfig",
        "gitignore",
        "go",
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
    "nvim-treesitter/playground",
    cmd = { "TSPlaygroundToggle" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
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
}
