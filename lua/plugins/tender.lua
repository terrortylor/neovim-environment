local plug = require("pluginman")

plug.add({
  url = "jacoborus/tender.vim",
  post_handler = function()
    vim.api.nvim_command("colorscheme tender")
  end
})
