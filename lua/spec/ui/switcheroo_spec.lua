local testModule = require('ui.switcheroo')
local api
local mock = require('luassert.mock')
local spy = require('luassert.spy')
local stub = require('luassert.stub')
local match = require('luassert.match')

describe('ui.switcheroo', function()

  before_each(function()
    api = mock(vim.api, true)
  end)

  after_each(function()
    mock.revert(api)
  end)

  describe('create_switch_map', function()
    it('Should return map with all switcheroo', function()
      local actual = testModule.create_switch_map(testModule.swapperoos)

      local expected = {
        ["true"] = "false",
        ["false"] = "true",
        ["=="] = "!=",
        ["!="] = "=="
      }
      assert.are.same(expected, actual)
    end)
  end)
end)

