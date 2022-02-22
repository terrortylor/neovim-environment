local testModule
local api
local mock = require("luassert.mock")
local stub = require("luassert.stub")

describe("ui.wndow", function()
	before_each(function()
		testModule = require("ui.window")
		api = mock(vim.api, true)
	end)

	after_each(function()
		mock.revert(api)
	end)

	describe("delete_buffer_keep_window", function()
		it("Should print message if buffer modified", function()
			local log = require("util.log")
			stub(log, "error")
			api.nvim_buf_get_option.on_call_with(0, "modified").returns(true)

			testModule.delete_buffer_keep_window()

			assert.stub(log.error).was_called_with(testModule.error_modified)

			log.error:revert()
		end)

		it("Should call change_buffer for each window and delete current buf", function()
			stub(vim, "cmd")
			api.nvim_buf_get_option.on_call_with(0, "modified").returns(false)
			-- set current window
			api.nvim_get_current_win.returns(50)
			-- set current buffer, to delete
			api.nvim_get_current_buf.returns(1)
			api.nvim_list_wins.returns({ 100, 50 })
			stub(testModule, "change_buffer")

			testModule.delete_buffer_keep_window()

			assert.stub(testModule.change_buffer).was_called_with(100, 1)
			assert.stub(testModule.change_buffer).was_called_with(50, 1)
			assert.stub(api.nvim_set_current_win).was_called_with(50)
			assert.stub(vim.cmd).was_called_with("bdelete " .. 1)

			testModule.change_buffer:revert()
		end)
	end)

	describe("change_buffer", function()
		it("Should load alternate file if exists", function()
			stub(vim, "cmd")
			api.nvim_win_get_buf.on_call_with(5).returns(1)
			local buf_util = require("util.buffer")
			stub(buf_util, "get_buf_id").returns(199)
			api.nvim_buf_is_loaded.on_call_with(199).returns(true)

			testModule.change_buffer(5, 1)

			assert.stub(api.nvim_set_current_win(5))
			assert.stub(vim.cmd).was_called_with("buffer #")

			buf_util.get_buf_id:revert()
		end)

		it("Should call bnext if no alternative", function()
			stub(vim, "cmd")
			-- TODO how to chain return values?
			api.nvim_win_get_buf.on_call_with(5).returns(1).returns(3)
			local buf_util = require("util.buffer")
			stub(buf_util, "get_buf_id").returns(0)
			api.nvim_buf_is_loaded.on_call_with(0).returns(false)

			testModule.change_buffer(5, 1)

			assert.stub(api.nvim_set_current_win(5))
			assert.stub(vim.cmd).was_called_with("bnext")
			assert.stub(vim.cmd).was_called_with("enew")
			-- TODO once worked out chain returns on spy have sperate test for:
			-- assert.stub(vim.api).was_not_called_with("enew")

			buf_util.get_buf_id:revert()
		end)
	end)
end)
