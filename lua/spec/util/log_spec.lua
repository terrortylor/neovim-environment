describe("util.log", function()
	local testModule
	local api
	local mock = require("luassert.mock")

	before_each(function()
		api = mock(vim.api, true)
		testModule = require("util.log")
	end)

	after_each(function()
		mock.revert(api)
	end)

	local function assert_message(mockedApi, hl, msg)
		assert.stub(mockedApi.nvim_command).was_called_with("echohl " .. hl)
		assert.stub(mockedApi.nvim_command).was_called_with('echom "' .. msg .. '"')
		assert.stub(mockedApi.nvim_command).was_called_with("echohl None")
	end

	local function assert_message_not(mockedApi, hl, msg)
		assert.stub(mockedApi.nvim_command).was_not_called_with("echohl " .. hl)
		assert.stub(mockedApi.nvim_command).was_not_called_with('echom "' .. msg .. '"')
		assert.stub(mockedApi.nvim_command).was_not_called_with("echohl None")
	end

	describe("log_message", function()
		it("Should not print message if invalid level", function()
			testModule.log_message("goat", "cheesy message")

			assert_message(api, "ErrorMsg", "ERROR: Invalid log level: goat")
		end)

		it("Should print message if level <= to set LOG_LEVEL", function()
			_G.LOG_LEVEL = "DEBUG"

			testModule.log_message("ERROR", "Some log message")
			assert_message(api, "ErrorMsg", "ERROR: Some log message")

			mock.revert(api)
			api = mock(vim.api, true)
			testModule.log_message("INFO", "Some log message")
			assert_message(api, "None", "INFO: Some log message")

			_G.LOG_LEVEL = "INFO"

			mock.revert(api)
			api = mock(vim.api, true)
			testModule.log_message("ERROR", "Some log message")
			assert_message(api, "ErrorMsg", "ERROR: Some log message")

			mock.revert(api)
			api = mock(vim.api, true)
			testModule.log_message("INFO", "Some log message")
			assert_message(api, "None", "INFO: Some log message")

			mock.revert(api)
			api = mock(vim.api, true)
			testModule.log_message("DEBUG", "Some log message")
			assert_message_not(api, "None", "DEBUG: Some log message")
		end)

		local test_table = {
			ERROR = "ErrorMsg",
			WARN = "WarningMsg",
			INFO = "None",
			DEBUG = "None",
		}

		for err, hl in pairs(test_table) do
			it("Should print log message as desired level: " .. err, function()
				_G.LOG_LEVEL = "DEBUG"

				testModule.log_message(err, "Some log message")

				assert_message(api, hl, err .. ": Some log message")

				mock.revert(api)
			end)
		end
	end)

	describe("metatable created methods", function()
		it("Should allow all method calls expected", function()
			_G.LOG_LEVEL = "DEBUG"

			testModule.error("This is a message")
			assert_message(api, "ErrorMsg", "ERROR: This is a message")

			testModule.warn("This is a message")
			assert_message(api, "WarningMsg", "WARN: This is a message")

			testModule.info("This is a message")
			assert_message(api, "None", "INFO: This is a message")

			testModule.debug("This is a message")
			assert_message(api, "None", "DEBUG: This is a message")
		end)
	end)
end)
