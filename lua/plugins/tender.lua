local plug = require("pluginman")

plug.add({
  url = "jacoborus/tender.vim",
  post_handler = function()
    vim.cmd("colorscheme tender")
  end
})
