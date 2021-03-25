local plug = require("pluginman")

plug.add({
  url = "terrortylor/nvim-comment",
  package = "myplugins",
  -- TODO make opt and main defaults
  branch = "main",
  post_handler = function()
    require('nvim_comment').setup()
  end
})
