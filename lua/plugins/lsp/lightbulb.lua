vim.cmd("packadd nvim-lightbulb")
require("nvim-lightbulb").update_lightbulb({})

require("util.config").create_autogroups({
  update_lightbulb = {
    { "CursorHold,CursorHoldI", "*", "lua require'nvim-lightbulb'.update_lightbulb()" },
  },
})

vim.opt.updatetime = 500
