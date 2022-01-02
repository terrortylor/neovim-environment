local utils = require('util.test_utils')

describe("todo_lists", function()
  local lines = [[
# This is a header

bla bla bla

## A differnt header

This is another paragraph

## This is not expected

Blurgh
]]

  it("Should jump to next pattern matching in direction", function()
    utils.buf_from_multiline(lines)

    -- Start on first header
    vim.api.nvim_win_set_cursor(0, {1,0})
    utils.send_keys(":lua require('ui.buffer.nav').find_next('/', '^#')<CR>")

    local line = vim.api.nvim_get_current_line()
    assert.are.same("## A differnt header", line)

    -- go back to first
    utils.send_keys(":lua require('ui.buffer.nav').find_next('?', '^#')<CR>")

    line = vim.api.nvim_get_current_line()
    assert.are.same("# This is a header", line)
  end)
end)

