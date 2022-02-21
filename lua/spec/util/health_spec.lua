local testModule
local api
local mock = require('luassert.mock')
local stub = require('luassert.stub')
local spy = require('luassert.spy')

describe('util.health', function()

  before_each(function()
    testModule = require('util.health')
    testModule.required_bins = {}
    -- api = mock(vim.api, true)
  end)

  after_each(function()
    -- mock.revert(api)
  end)

  describe('register_required_binary', function()
    it('should add binary and register descriptions', function()
      local bin_descs = testModule.required_bins["boat"]
      assert.are.equal(nil, bin_descs)

      testModule.register_required_binary("boat", "to sail with")
      bin_descs = testModule.required_bins["boat"]
      assert.are.same({ "to sail with" }, bin_descs)

      testModule.register_required_binary("boat", "move stuff")
      bin_descs = testModule.required_bins["boat"]
      assert.are.same({ "to sail with", "move stuff" }, bin_descs)

      testModule.register_required_binary("car", "vroom vroom")
      bin_descs = testModule.required_bins["car"]
      assert.are.same({ "vroom vroom" }, bin_descs)
    end)
  end)

  describe('get_health_table', function ()
    it('should be empty if nothing registerd', function ()
      local empty_health_table = testModule.generate_empty_health_table()
      local htbl = testModule.get_health_table()
      assert.are.same(empty_health_table, htbl)
    end)

    it('should contain missing binary and descriptions', function ()
      testModule.register_required_binary("notexists", "required for something")
      testModule.register_required_binary("notexists", "LOUD NOISES")
      local htbl = testModule.get_health_table()
      assert.are.same({missing_binaries = {
        notexists = {
          "required for something",
          "LOUD NOISES"
        }
      }}, htbl)
    end)
  end)
end)

