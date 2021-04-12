local plug = require("pluginman")

plug.add({
  url = "terrortylor/nvim-httpclient",
  package = "myplugins",
  -- TODO make opt and main defaults
  branch = "main",
  post_handler = function()
    require('nvim-httpclient').setup()
  end
})

