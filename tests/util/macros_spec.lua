local utils = require('util.test_utils')

describe("macros", function()
  it("should run macro, and restore register", function()
    local expected = [[
test
]]

    vim.fn.setreg("q", "cheese", "v")

    require('util.macros').run_macro([[itest]], "q")

    local actual = utils.get_buf_as_multiline()
    assert.are.same(expected, actual)

    local reg = vim.fn.getreg("q")
    assert.are.same("cheese", reg)
  end)
end)


