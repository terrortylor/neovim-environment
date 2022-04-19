local testModule
local stub = require("luassert.stub")

describe("util.health", function()
  before_each(function()
    testModule = require("util.health")
    testModule.required_bins = {}
  end)

  describe("register_required_binary", function()
    it("should add binary and register descriptions", function()
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

  describe("get_health_table", function()
    it("should contain missing binary and descriptions", function()
      local health = require("health")
      stub(health, "report_start").on_call_with("my-config-health")
      stub(health, "report_info").on_call_with("Missing binary: notexists : required for something")
      stub(health, "report_info").on_call_with("Missing binary: notexists : LOUD NOISES")
      testModule.register_required_binary("notexists", "required for something")
      testModule.register_required_binary("notexists", "LOUD NOISES")
      testModule.check()
    end)
  end)
end)
