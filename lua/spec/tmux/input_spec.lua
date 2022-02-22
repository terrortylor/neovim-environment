describe("tmux.input", function()
	local testModule
	local input
	local stub = require("luassert.stub")

	before_each(function()
		testModule = require("tmux.input")
	end)

	describe("get_pane", function()
		it("Should call tmux display-panes and prompt for input", function()
			input = require("util.input")
			stub(input, "get_user_input").on_call_with("Enter pane: ").returns("3")
			-- FIXME why is stub of execute reqiured, shouldn't stub of
			-- get_user_input handle that?
			stub(os, "execute")

			local result = testModule.get_pane("Enter pane: ")

			assert.stub(input.get_user_input).was_called_with("Enter pane: ")
			assert.are.equal("3", result)

			os.execute:revert()
			input.get_user_input:revert()
		end)
	end)
end)
