local testModule

describe("tmux.commands", function()
  before_each(function()
    testModule = require("tmux.commands")
  end)

  after_each(function()
    testModule.clear_identifier("default")
  end)

  describe("get_identifier", function()
   it("should return nil if identifier does not exists", function()
     local result = testModule.get_identifier("default")
     assert.equal(nil, result)
   end)

   it("should return command structure if identifier does exists", function()
     testModule.add_complete_command("default", 1, "pwd")
     local result = testModule.get_identifier("default")
     assert.are_not.equal(nil, result)
   end)
  end)

  describe("get_pane_and_command", function()
    it("should return the latest added command", function()
     local result = testModule.get_identifier("default")
     assert.equal(nil, result)

     -- add a command
     testModule.add_complete_command("default", 1, "pwd")
     result = testModule.get_identifier("default")
     -- check one commands
     assert.equal(1, #result.command_stack)
     local pane, command = testModule.get_pane_and_command("default")
     assert.equal(1, pane)
     assert.equal("pwd", command)

     -- add a new command
     testModule.add_complete_command("default", 1, "ls")
     result = testModule.get_identifier("default")
     -- check two commands
     assert.equal(2, #result.command_stack)
     -- check command updated
     pane, command = testModule.get_pane_and_command("default")
     assert.equal(1, pane)
     assert.equal("ls", command)
    end)
  end)
end)
