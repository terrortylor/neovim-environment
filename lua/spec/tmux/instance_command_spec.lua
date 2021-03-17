local testModule

describe('tmux.instance_command', function()
  before_each(function()
    testModule = require('tmux.instance_command')
  end)

  describe("set_instance_command", function()
    it("Should add commands to expected instance's list of commands", function()
      testModule.set_instance_command("1", "test")
      assert.same(testModule.instance_commands, {["1"] = {"test"}})

      testModule.set_instance_command("1", "stack")
      assert.same(testModule.instance_commands, {["1"] = {"test", "stack"}})

      testModule.set_instance_command("2", "pwd")
      assert.same(testModule.instance_commands, {["1"] = {"test", "stack"}, ["2"] = {"pwd"}})
    end)
  end)

  describe("get_instance_command", function()
    it("Should return nil if instance key doesn't exist", function()
      local result = testModule.get_instance_command("3")

      assert.equal(nil, result)
    end)

    it("Should return the last command set against a instance", function()
      testModule.set_instance_command("4", "pwd")
      local result = testModule.get_instance_command("4")

      assert.equal("pwd", result)

      testModule.set_instance_command("4", "ls -al")
      result = testModule.get_instance_command("4")

      assert.equal("ls -al", result)
    end)
  end)

  describe("get_instance_history", function()
    it("Should return nil if no commands sent to a instance", function()
      local result = testModule.get_instance_history("XXX")
      assert.equal(nil, result)

    end)
    it("Should return list of all commads sent to instance", function()
      testModule.set_instance_command("5", "pwd")
      local result = testModule.get_instance_history("5")

      assert.same({"pwd"}, result)

      testModule.set_instance_command("5", "ls -al")
      result = testModule.get_instance_history("5")

      assert.same({"pwd", "ls -al"}, result)
    end)
  end)
end)
