-- TODO add tests
-- status reporting wrong when installing plugin wiht no docs
local api = vim.api
local draw = require('ui.window.draw')

local M = {}

local plugins = {}
local summary_buf

function M.set_plugins(p)
  plugins = p
end

function M.summary()
  if not summary_buf then
    summary_buf = api.nvim_create_buf(false, true)
    api.nvim_buf_set_option(summary_buf, "filetype", "pluginsstatus")
  end
  draw.open_draw(summary_buf)
  local details = {"Plugin Summary:", ""}
  for _,plug in pairs(plugins) do
    table.insert(details, plug:get_name())
    table.insert(details, plug:to_string())
  end
  api.nvim_buf_set_lines(summary_buf, 0 , -1, false, details)
end

return M
