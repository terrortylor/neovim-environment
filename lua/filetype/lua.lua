local util = require('util.config')

local buf_options = {
  -- Indentation
  -- This is getting overridden in anohter external plugin
  tabstop       = 2,
  softtabstop   = 0,
  expandtab     = true,
  shiftwidth    = 2,
}

util.set_buf_options(buf_options)
