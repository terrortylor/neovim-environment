local testModule
local api
local mock = require('luassert.mock')

describe('util.bridge', function()

  before_each(function()
    testModule = require('util.bridge')
    api = mock(vim.api, true)
  end)

  after_each(function()
    mock.revert(api)
  end)

  describe("metatable function calls", function()
    it("should call metatable functions", function()
      testModule.nmap("lhs", "rhs")
      assert.stub(api.nvim_set_keymap).was_called_with("n", "lhs", "rhs", {noremap = false})
      testModule.nnoremap("lhs", "rhs")
      assert.stub(api.nvim_set_keymap).was_called_with("n", "lhs", "rhs", {noremap = true})
      testModule.nmap("lhs", "rhs", "description")
      assert.stub(api.nvim_set_keymap).was_called_with("n", "lhs", "rhs", {noremap = false, desc = "description"})
    end)
  end)
end)
