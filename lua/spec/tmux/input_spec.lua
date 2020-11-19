local testModule

describe("tmux library", function()
  describe("input", function()
    setup(function()
      _G._TEST = true
      _G.vim = {
        api = require("spec.vim_api_helper")
      }
      testModule = require("tmux.input")
    end)

    teardown(function()
      _G._TEST = nil
    end)

    describe("get_pane", function()
      it("Should call tmux display-panes and prompt for input", function()
        -- FIXME why is stub of execute reqiured, shouldn't stub of
        -- get_user_input handle that?
        stub(os, 'execute')
        stub(testModule, 'get_user_input').on_call_with('Enter pane: ').returns("3")

        local result = testModule.get_pane("Enter pane: ")

        assert.stub(testModule.get_user_input).was_called_with("Enter pane: ")
        assert.are.equal("3", result)

        os.execute:revert()
        testModule.get_user_input:revert()
      end)
    end)

    describe("get_user_input", function()
      it("Should prompt with expect message", function()
        local m = mock(vim.api, true)
        m.nvim_call_function.on_call_with("input", {{prompt = "How many goats? "}}).returns("loads")

        local result = testModule.get_user_input("How many goats? ")

        assert.stub(m.nvim_call_function).was_called_with("inputsave", {})
        assert.stub(m.nvim_call_function).was_called_with("input", {{prompt = "How many goats? "}})
        assert.stub(m.nvim_call_function).was_called_with("inputrestore", {})
        assert.stub(m.nvim_command).was_called_with("normal :<ESC>")
        assert.are.equal("loads", result)

        mock.revert(m)
      end)

      it("Should prompt with expected message and default value", function()
        local m = mock(vim.api, true)
        m.nvim_call_function.on_call_with("input", {{prompt = "How many goats? ", default = "quite a lot"}})
          .returns("loads")

        local result = testModule.get_user_input("How many goats? ", "quite a lot")

        assert.stub(m.nvim_call_function).was_called_with("inputsave", {})
        assert.stub(m.nvim_call_function)
          .was_called_with("input", {{prompt = "How many goats? ", default = "quite a lot"}})
        assert.stub(m.nvim_call_function).was_called_with("inputrestore", {})
        assert.stub(m.nvim_command).was_called_with("normal :<ESC>")
        assert.are.equal("loads", result)

        mock.revert(m)
      end)
    end)
  end)
end)
