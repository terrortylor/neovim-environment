local plug = require("pluginman")

plug.add({
  url = "nvim-treesitter/nvim-treesitter",
  post_handler = function()
    require'nvim-treesitter.configs'.setup {
      ensure_installed = {"javascript", "typescript", "lua", "go"},
      highlight = {
        enable = true,
      },
      query_linter = {
        enable = true,
        use_virtual_text = true,
        lint_events = {"BufWrite", "CursorHold"},
      },
    }
  end
})

-- https://github.com/nvim-treesitter/playground
plug.add("nvim-treesitter/playground")
