local plug = require("pluginman")

plug.add({
  url = "kosayoda/nvim-lightbulb",
  post_handler  = function()
    require'nvim-lightbulb'.update_lightbulb {}

    require('util.config').create_autogroups({
      return_to_last_edit_in_buffer = {
        {"CursorHold,CursorHoldI", "*", "lua require'nvim-lightbulb'.update_lightbulb()"}
      }})

    vim.api.nvim_set_option("updatetime", 500)
  end
})

