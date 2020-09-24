local api = vim.api
local util = require('util.config')

local win_options = {
  -- Folding
  foldmethod = "marker",
  foldenable = true,
}

util.set_win_options(win_options)

local is_keyword = api.nvim_buf_get_option(0, "iskeyword")
local buf_options = {
  -- FIXME this seems to add ,- twice but comma is required
  iskeyword = is_keyword .. ",-",
}

util.set_buf_options(buf_options)
