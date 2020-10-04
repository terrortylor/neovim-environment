local api = vim.api
local parser = require('restclient.parser')
local builder = require('restclient.builder')
local M = {}

function M.run()
  local buf = api.nvim_win_get_buf(0)
  -- TODO add check to ensure correct filetype
  local buf_lines = api.nvim_buf_get_lines(buf, 0, api.nvim_buf_line_count(buf), false)
  local rest_blocks = parser.parse_lines(buf_lines)

  for _,v in pairs(rest_blocks) do
    print(builder.build_curl(v))
  end
end

return M
