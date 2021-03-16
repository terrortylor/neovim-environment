local testModule
local api
local mock = require('luassert.mock')

describe("util", function()
  describe("input", function()
    before_each(function()
      testModule = require("util.input")
      api = mock(vim.api, true)
    end)

    after_each(function()
      mock.revert(api)
    end)

    describe("get_user_input", function()
      it("Should prompt with expect message", function()
        api.nvim_call_function.on_call_with("input", {{prompt = "How many goats? "}}).returns("loads")

        local result = testModule.get_user_input("How many goats? ")

        assert.stub(api.nvim_call_function).was_called_with("inputsave", {})
        assert.stub(api.nvim_call_function).was_called_with("input", {{prompt = "How many goats? "}})
        assert.stub(api.nvim_call_function).was_called_with("inputrestore", {})
        assert.stub(api.nvim_command).was_called_with("normal :<ESC>")
        assert.are.equal("loads", result)

        mock.revert(api)
      end)

      it("Should prompt with expected message and default value", function()
        api.nvim_call_function.on_call_with("input", {{prompt = "How many goats? ", default = "quite a lot"}})
          .returns("loads")

        local result = testModule.get_user_input("How many goats? ", "quite a lot")

        assert.stub(api.nvim_call_function).was_called_with("inputsave", {})
        assert.stub(api.nvim_call_function)
          .was_called_with("input", {{prompt = "How many goats? ", default = "quite a lot"}})
        assert.stub(api.nvim_call_function).was_called_with("inputrestore", {})
        assert.stub(api.nvim_command).was_called_with("normal :<ESC>")
        assert.are.equal("loads", result)

        mock.revert(api)
      end)
    end)
  end)
end)
