local plug = require("pluginman")

plug.add({
  url = "vim-test/vim-test",
  post_handler = function()
    vim.api.nvim_set_var("test#strategy", "neovim")
  end
})
