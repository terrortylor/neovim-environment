local blame = require('git.lib.blame')

local M = {}

-- Define settings
M.defaults = {
  blame_close = {"<ESC>", "<CR>"}
}

--- Wrapper for running git blame
-- calls library blame function, with mappings used to close floatint window
-- @param line_start first line to show blame for
-- @param line_end last line to show blame for
function M.blame(line_start, line_end)
  blame.go(line_start, line_end, M.defaults["blame_close"])
end

--- Used to setup the plugin, sets up commands etc
function M.setup()
  vim.cmd("command! -range GitBlame lua require('git').blame(<line1>, <line2>)")
end

return M
