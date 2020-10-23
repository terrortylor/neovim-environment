local testModule

describe('util', function()
  describe('log', function()
    setup(function()
      _G.vim = {
        api = require('spec.vim_api_helper')
      }
      testModule = require('util.log')
    end)

    local function assert_message(mock, hl, msg)
        assert.stub(mock.nvim_command).was_called_with('echohl ' .. hl)
        assert.stub(mock.nvim_command).was_called_with('echom "' .. msg .. '"')
        assert.stub(mock.nvim_command).was_called_with('echohl None')
    end

    local function assert_message_not(mock, hl, msg)
        assert.stub(mock.nvim_command).was_not_called_with('echohl ' .. hl)
        assert.stub(mock.nvim_command).was_not_called_with('echom "' .. msg .. '"')
        assert.stub(mock.nvim_command).was_not_called_with('echohl None')
    end

    describe('log_message', function()
      it('Should not print message if invalid level', function()
        local m = mock(vim.api, true)

        testModule.log_message('goat', 'cheesy message')

        assert_message(m, 'ErrorMsg', 'ERROR: Invalid log level: goat')

      end)

      it('Should print message if level <= to set LOG_LEVEL', function()
        _G.LOG_LEVEL = 'DEBUG'

        local m = mock(vim.api, true)
        testModule.log_message('ERROR', 'Some log message')
        assert_message(m, 'ErrorMsg','ERROR: Some log message')

        mock.revert(m)
        local m = mock(vim.api, true)
        testModule.log_message('INFO', 'Some log message')
        assert_message(m, 'None','INFO: Some log message')

        _G.LOG_LEVEL = 'INFO'

        mock.revert(m)
        local m = mock(vim.api, true)
        testModule.log_message('ERROR', 'Some log message')
        assert_message(m, 'ErrorMsg','ERROR: Some log message')

        mock.revert(m)
        local m = mock(vim.api, true)
        testModule.log_message('INFO', 'Some log message')
        assert_message(m, 'None','INFO: Some log message')

        mock.revert(m)
        local m = mock(vim.api, true)
        testModule.log_message('DEBUG', 'Some log message')
        assert_message_not(m, 'None','DEBUG: Some log message')
      end)

      local test_table = {
        ERROR = 'ErrorMsg',
        WARN = 'WarningMsg',
        INFO = 'None',
        DEBUG = 'None',
      }

      for err,hl in pairs(test_table) do
        it('Should print log message as desired level: ' .. err, function()
          _G.LOG_LEVEL = 'DEBUG'
          -- TODO move ths to before block
          mock.revert(m)
          local m = mock(vim.api, true)

          testModule.log_message(err, 'Some log message')

          assert_message(m, hl, err .. ': Some log message')
        end)
      end
    end)

    describe('metatable created methods', function()
      it('Should allow all method calls expected', function()
        _G.LOG_LEVEL = 'DEBUG'
        local m = mock(vim.api, true)

        testModule.error('This is a message')
        assert_message(m, 'ErrorMsg', 'ERROR: This is a message')

        testModule.warn('This is a message')
        assert_message(m, 'WarningMsg', 'WARN: This is a message')

        testModule.info('This is a message')
        assert_message(m, 'None', 'INFO: This is a message')

        testModule.debug('This is a message')
        assert_message(m, 'None', 'DEBUG: This is a message')
      end)
    end)
  end)
end)
