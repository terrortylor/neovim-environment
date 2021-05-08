local plug = require("pluginman")

plug.add({
  url = "nvim-treesitter/nvim-treesitter",
  post_handler = function()
    require'nvim-treesitter.configs'.setup {
      ensure_installed = {"javascript", "typescript", "lua"},
      highlight = {
        enable = true,
      },
    }
  end
})

