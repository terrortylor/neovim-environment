return {
  {
    "okuuva/auto-save.nvim",
    cmd = "ASToggle", -- optional for lazy loading on command
    event = { "InsertLeave", "TextChanged" }, -- optional for lazy loading on trigger events
    opts = {
      -- Whilst default behaviour, plugin doesn't work unless setup called, so opts needs to be blank or have something set init
      enabled = true,
      condition = function()
        local ignore_filetype = require("util.buffer").ignore_filetype
        return not ignore_filetype()
      end,
    },
  },
}
