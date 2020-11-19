local testModule

describe("tmux library", function()
  describe("commands", function()
    setup(function()
      _G._TEST = true

      _G.vim = {
        api = require("spec.vim_api_helper")
      }
      testModule = require("tmux.commands")
    end)

    teardown(function()
      _G._TEST = nil
    end)

    describe("get_instance_pane", function()
      it("Should prompt and return for pane if not set for instance", function()
        local input = require("tmux.input")
        stub(input, "get_pane").returns(5)

        local result = testModule.get_instance_pane(1)

        assert.equal(5, result)

        input.get_pane:revert()
      end)

      it("Should return instance's pane", function()
        local input = require("tmux.input")
        stub(input, "get_pane").returns(5)

        local result = testModule.get_instance_pane(1)

        assert.equal(5, result)
      end)

      it("Should prompt for pane if clear_first paramater given", function()
        local input = require("tmux.input")
        stub(input, "get_pane").returns(8)

        local result = testModule.get_instance_pane(1, true)

        assert.equal(8, result)

        input.get_pane:revert()
      end)

      it("Should handle multiple instances", function()
        local input = require("tmux.input")
        stub(input, "get_pane").returns(15)

        local result = testModule.get_instance_pane(2)

        assert.equal(15, result)

        input.get_pane:revert()

        result = testModule.get_instance_pane(2)

        assert.equal(15, result)

        -- check pane from previous instance test
        result = testModule.get_instance_pane(1)

        assert.equal(8, result)
      end)
    end)

    describe("guarded_send_command", function()
      it("Should exit if pane not set", function()
        stub(testModule, "get_instance_pane").on_call_with(1).returns(nil)
        local log = require("util.log")
        stub(log, "error")

        testModule._guarded_send_command(1, function() end)

        assert.stub(testModule.get_instance_pane).was_called_with(1)
        assert.stub(log.error).was_called_with("Pane not set")

        -- reset stubs
        log.error:revert()
        testModule.get_instance_pane:revert()
      end)

      it("Should exit if passed function returns nil", function()
        stub(testModule, "get_instance_pane").on_call_with(1).returns(100)
        local log = require("util.log")
        stub(log, "error")
        local test = {
          func = function() print("not printed") end
        }
        stub(test, "func").returns(nil)

        testModule._guarded_send_command(1, test.func)

        assert.stub(testModule.get_instance_pane).was_called_with(1)
        assert.stub(test.func).was_called()
        assert.stub(log.error).was_called_with("Command empty")

        -- reset stubs
        log.error:revert()
        testModule.get_instance_pane:revert()
      end)

      it("Should execute command if pane set and command not nil", function()
        stub(testModule, "get_instance_pane").on_call_with(1).returns(100)
        local test = {
          func = function() return "brap" end
        }
        local dispatch = require("tmux.dispatch")
        stub(dispatch, 'execute')

        testModule._guarded_send_command(1, test.func)

        assert.stub(testModule.get_instance_pane).was_called_with(1)
        assert.stub(dispatch.execute).was_called_with(100, "brap")

        -- reset stubs
        testModule.get_instance_pane:revert()
        dispatch.execute:revert()
      end)
    end)

    describe("send_command_to_pane", function()
      local dispatch

      setup(function()
        stub(testModule, "get_instance_pane").on_call_with(1).returns(100)
        dispatch = require("tmux.dispatch")
        stub(dispatch, 'execute')
      end)

      teardown(function()
        testModule.get_instance_pane:revert()
        dispatch.execute:revert()
      end)

      it("Should execute default command if no instance commands", function()
        local comstack = require('tmux.instance_command')
        stub(comstack, "get_instance_command").returns(nil)

        testModule.send_command_to_pane(1)

        assert.stub(dispatch.execute).was_called_with(100, "^P")
      end)

      it("Should execute retrieved instance command", function()
        local comstack = require('tmux.instance_command')
        stub(comstack, "get_instance_command").returns("ls -al")

        testModule.send_command_to_pane(1)

        assert.stub(dispatch.execute).was_called_with(100, "ls -al")
      end)
    end)

    describe("set_instance_command", function()
      local dispatch

      setup(function()
        stub(testModule, "get_instance_pane").on_call_with(1).returns(100)
        dispatch = require("tmux.dispatch")
        stub(dispatch, 'execute')
      end)

      teardown(function()
        testModule.get_instance_pane:revert()
        dispatch.execute:revert()
      end)

      it("Should log error if input command is nil", function()
        local log = require("util.log")
        stub(log, "error")
        local input = require("tmux.input")
        stub(input, "get_user_input").returns(nil)

        testModule.set_instance_command(1)

        assert.stub(log.error).was_not_called("Command empty, not setting instance")
        assert.stub(dispatch.execute).was_not_called()
      end)

      it("Should add to instance stack and execute command", function()
        local input = require("tmux.input")
        stub(input, "get_user_input").returns("du -hcs *")
        local comstack = require('tmux.instance_command')
        stub(comstack, "set_instance_command")

        testModule.set_instance_command(1)

        assert.stub(comstack.set_instance_command).was_called_with(1, "du -hcs *")
        assert.stub(dispatch.execute).was_called_with(100, "du -hcs *")
      end)
    end)

    describe("send_one_off_command", function()
      it("Should execute command", function()
        local dispatch = require("tmux.dispatch")
        stub(dispatch, 'execute')
        local input = require("tmux.input")
        -- first return for send_command_to_pane
        -- second return called from send_one_off_command
        stub(input, 'get_user_input').returns("ls -al").returns("df -h")
        stub(testModule, "get_instance_pane").on_call_with(1).returns(100)

        -- call command from stack
        testModule.send_command_to_pane(1)
        assert.stub(dispatch.execute).was_called_with(100, "ls -al")
        dispatch.execute:revert()
        stub(dispatch, 'execute')

        -- call one off command
        testModule.send_one_off_command(1)
        assert.stub(dispatch.execute).was_called_with(100, "df -h")
        dispatch.execute:revert()
        stub(dispatch, 'execute')

        -- call command from stack
        testModule.send_command_to_pane(1)
        assert.stub(dispatch.execute).was_called_with(100, "ls -al")
        dispatch.execute:revert()

        testModule.get_instance_pane:revert()
      end)
    end)

    describe("edit_last_command", function()
      local dispatch
      local comstack
      local input

      setup(function()
        stub(testModule, "get_instance_pane").on_call_with(1).returns(100)
        dispatch = require("tmux.dispatch")
        stub(dispatch, 'execute')
        comstack = require('tmux.instance_command')
        stub(comstack, "set_instance_command")
        input = require("tmux.input")
        stub(input, "get_user_input").returns("ls -al")
      end)

      teardown(function()
        testModule.get_instance_pane:revert()
        dispatch.execute:revert()
        comstack.set_instance_command:revert()
        comstack.get_instance_command:revert()
        input.get_user_input:revert()
      end)

      it("Should call user input with empty string if no command history", function()
        stub(comstack, "get_instance_command").returns("")

        testModule.edit_last_command(1)

        assert.stub(input.get_user_input).was_called_with("Command: ", "")
        assert.stub(comstack.set_instance_command).was_called_with(1, "ls -al")
        assert.stub(dispatch.execute).was_called()
      end)

      it("Should call user input with last instance command", function()
        stub(comstack, "get_instance_command").returns("pwd")

        testModule.edit_last_command(1)

        assert.stub(input.get_user_input).was_called_with("Command: ", "pwd")
        assert.stub(comstack.set_instance_command).was_called_with(1, "ls -al")
        assert.stub(dispatch.execute).was_called()
      end)
    end)

    describe("scroll", function()
      local dispatch

      setup(function()
        dispatch = require("tmux.dispatch")
        stub(dispatch, "scroll")
      end)

      teardown(function()
        testModule.get_instance_pane:revert()
        dispatch.scroll:revert()
      end)

      it("Should exit if pane not set", function()
        stub(testModule, "get_instance_pane").on_call_with(1).returns(nil)
        local log = require("util.log")
        stub(log, "error")

        testModule.scroll(true, 1)

        assert.stub(log.error).was_called_with("Pane not set")
        assert.stub(dispatch.scroll).was_not_called()

        log.error:revert()
      end)

      it("Should call dispatch scroll up", function()
        stub(testModule, "get_instance_pane").on_call_with(1).returns(100)

        testModule.scroll(true, 1)

        assert.stub(dispatch.scroll).was_called_with(100, true)
      end)

      it("Should call dispatch scroll down", function()
        stub(testModule, "get_instance_pane").on_call_with(1).returns(100)

        testModule.scroll(false, 1)

        assert.stub(dispatch.scroll).was_called_with(100, false)
      end)
    end)
  end)
end)
