local utils = require('util.test_utils')

describe("switcheroo", function()
  -- TODO shouldn't need this, integration tests should load the init.lua
  require('ui.switcheroo').setup()
  it("Should swap both key/value words in swapperoos", function()
  local input = { "true", "false" }
  local expected = { "false", "true" }

    utils.buf_from_table(input)

    vim.api.nvim_win_set_cursor(0, {1,0})
    utils.send_keys(":lua require('ui.switcheroo').do_switcheroo()<CR>")
    utils.send_keys("j:lua require('ui.switcheroo').do_switcheroo()<CR>")
    assert.are.same(expected, utils.get_buf_lines())
  end)
end)

