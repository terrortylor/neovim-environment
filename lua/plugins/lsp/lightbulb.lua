vim.cmd("packadd nvim-lightbulb")
require("nvim-lightbulb").update_lightbulb({})

vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
  pattern = "*",
  callback = function()
    require("nvim-lightbulb").update_lightbulb()
  end,
  group = vim.api.nvim_create_augroup("update_lightbulb", { clear = true }),
})

vim.opt.updatetime = 500
