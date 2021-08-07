local plug = require("pluginman")

plug.add({
  url = "norcalli/nvim-colorizer.lua",
  post_handler = function()
    require'colorizer'.setup()
  end
})
