local plug = require("pluginman")

plug.add({
  url = "kosayoda/nvim-lightbulb",
  post_handler  = function()
    require'nvim-lightbulb'.update_lightbulb {}
    vim.cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]
    vim.api.nvim_set_option("updatetime", 500)
  end
})

