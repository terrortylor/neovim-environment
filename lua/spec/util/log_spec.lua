local testModule

describe('util', function()
  describe('log', function()
    setup(function()
      testModule = require('util.log')
    end)

    describe('log_message', function()
      it('Should not print message if invalid level', function()
        stub(_G, 'print')

        testModule.log_message("goat", "cheesy message")

        assert.stub(_G.print).was_called_with('ERROR: Invalid log level: goat')

        _G.print:revert()
      end)

      it('Should print message if level <= to set LOG_LEVEL', function()
        _G.LOG_LEVEL = "DEBUG"

        stub(_G, 'print')
        testModule.log_message("ERROR", "Some log message")
        assert.stub(_G.print).was_called_with('ERROR: Some log message')

        testModule.log_message("INFO", "Some log message")
        assert.stub(_G.print).was_called_with('ERROR: Some log message')

        _G.LOG_LEVEL = "INFO"

        stub(_G, 'print')
        testModule.log_message("ERROR", "Some log message")
        assert.stub(_G.print).was_called_with('ERROR: Some log message')

        testModule.log_message("INFO", "Some log message")
        assert.stub(_G.print).was_called_with('ERROR: Some log message')

        testModule.log_message("DEBUG", "Some log message")
        assert.stub(_G.print).was_not_called_with('DEBUG: Some log message')
        _G.print:revert()
      end)

      local test_table = {
        "ERROR",
        "WARN",
        "INFO",
        "DEBUG",
      }

      for _,v in pairs(test_table) do
        it('Should print log message as desired level: ' .. v, function()
          _G.LOG_LEVEL = "DEBUG"
          stub(_G, 'print')

          testModule.log_message(v, "Some log message")

          assert.stub(_G.print).was_called_with(v .. ': Some log message')

          _G.print:revert()
        end)
      end
    end)

    describe('metatable created methods', function()
      it('Should allow all method calls expected', function()
        stub(_G, 'print')

        testModule.error("This is a message")
        assert.stub(_G.print).was_called_with("ERROR: This is a message")

        testModule.warn("This is a message")
        assert.stub(_G.print).was_called_with("WARN: This is a message")

        testModule.info("This is a message")
        assert.stub(_G.print).was_called_with("INFO: This is a message")

        testModule.debug("This is a message")
        assert.stub(_G.print).was_called_with("DEBUG: This is a message")

        testModule.asdf("This is a message")
        assert.stub(_G.print).was_not_called_with("ASDF: This is a message")

        _G.print:revert()
      end)
    end)
  end)
end)
