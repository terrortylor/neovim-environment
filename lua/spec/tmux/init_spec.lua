local testModule

describe('tmux library', function()
  describe('init', function()
    setup(function()
      _G._TEST = true
      _G.vim = {
        api = require('spec.vim_api_helper')
      }
      testModule = require('tmux')
    end)

    teardown(function()
      _G._TEST = nil
    end)

    describe('send_command_to_pane', function()
      it('Should call user input local methods then send command', function()
        -- Setup stubbed values
        local m = mock(vim.api, true)
        m.nvim_call_function.on_call_with('input', {'Enter pane to send command too: '}).returns(2)
        m.nvim_call_function.on_call_with('input', {'Enter command to send: '}).returns('pwd')
        stub(os, 'execute')
        testModule.send_command_to_pane()

        assert.are.equal(2, testModule._get_pane_number())
        assert.are.equal('pwd', testModule._get_user_command())
        assert.stub(m.nvim_command).was_called_with('wa')
        assert.stub(os.execute).was_called_with('tmux if-shell -F -t "2" "#{pane_in_mode}" "send-keys Escape" ""')
        assert.stub(os.execute).was_called_with('tmux send-keys -t "2" C-z "pwd" Enter')

        -- reset stubs
        os.execute:revert()
      end)
    end)

    describe('capture_pane_number', function()
      it('Should prompt for user input when empty, not when populated', function()
        -- Setup stubbed values
        local m = mock(vim.api, true)
        m.nvim_call_function.on_call_with('input', {'Enter pane to send command too: '}).returns(2)
        stub(os, 'execute')
        -- set up module, make sure pane number is empty
        testModule.clear_pane_number()
        assert.are.equal(nil, testModule._get_pane_number())

        -- call capture function
        testModule.capture_pane_number()

        -- check prompt behaviour
        assert.stub(os.execute).was_called_with('tmux display-panes')
        assert.stub(m.nvim_call_function).was_called_with('input', {'Enter pane to send command too: '})
        assert.are.equal(2, testModule._get_pane_number())

        -- reset stubs
        os.execute:revert()
        stub(os, 'execute')
        vim.api.nvim_call_function:revert()
        mock(vim.api, true)
        -- call capture function, not it's value is populated
        testModule.capture_pane_number()

        -- check prompt behaviour
        assert.stub(os.execute).was_not.called()
        assert.stub(m.nvim_call_function).was_not.called()
        assert.are.equal(2, testModule._get_pane_number())

        -- reset stubs
        os.execute:revert()
      end)
    end)

    describe('execute_user_command', function()
      it('Should print error if either value empty, otherwise run command', function()
        -- Setup
        stub(os, 'execute')
        stub(_G, 'print')
        testModule.clear_pane_number()
        testModule.clear_user_command()

        -- call capture function
        testModule.execute_user_command()

        -- assert execute not called
        assert.stub(os.execute).was_not_called()
        assert.stub(_G.print).was_called_with('Missing pane or command, not running')

        -- reset stubs
        os.execute:revert()
        _G.print:revert()
        stub(os, 'execute')
        stub(_G, 'print')

        -- setup for with values set
        local m = mock(vim.api, true)
        m.nvim_call_function.on_call_with('input', {'Enter pane to send command too: '}).returns(2)
        m.nvim_call_function.on_call_with('input', {'Enter command to send: '}).returns('pwd')
        testModule.capture_pane_number()
        testModule._capture_user_command()

        -- call capture function
        testModule.execute_user_command('pwd')

        -- assert execute called
        assert.stub(os.execute).was_called_with('tmux if-shell -F -t "2" "#{pane_in_mode}" "send-keys Escape" ""')
        assert.stub(os.execute).was_called_with('tmux send-keys -t "2" C-z "pwd" Enter')
        assert.stub(_G.print).was_not_called_with('Missing pane or command, not running')

        -- reset stubs
        os.execute:revert()
        _G.print:revert()
      end)
    end)

    describe('capture_user_command', function()
      it('Should prompt for user input when empty, not when populated', function()
        -- Setup stubbed values
        local m = mock(vim.api, true)
        m.nvim_call_function.on_call_with('input', {'Enter command to send: '}).returns('pwd')
        -- set up module, make sure pane number is empty
        testModule.clear_user_command()
        assert.are.equal(nil, testModule._get_user_command())

        -- call capture function
        testModule._capture_user_command()

        -- check prompt behaviour
        assert.stub(m.nvim_call_function).was_called_with('input', {'Enter command to send: '})
        assert.are.equal('pwd', testModule._get_user_command())

        -- reset stubs
        vim.api.nvim_call_function:revert()
        mock(vim.api, true)
        -- call capture function, not it's value is populated
        testModule._capture_user_command()

        -- check prompt behaviour
        assert.stub(m.nvim_call_function).was_not.called()
        assert.are.equal('pwd', testModule._get_user_command())
      end)
    end)

    describe('send_one_off_command_to_pane', function()
      it('Should prompt for user input, but not send if pane not set', function()
        -- Setup stubbed values
        local m = mock(vim.api, true)
        m.nvim_call_function.on_call_with('input', {'Enter pane to send command too: '})
        m.nvim_call_function.on_call_with('input', {'Enter command: '}).returns('pwd')
        stub(testModule, 'execute_user_command')
        stub(os, 'execute')
        testModule.clear_pane_number()

        -- call capture function
        testModule.send_one_off_command_to_pane()

        assert.stub(m.nvim_call_function).was_called_with('input', {'Enter command: '})
        assert.stub(testModule.execute_user_command).was_not_called_with('pwd')

        mock.revert(m)
      end)

      it('Should prompt for user input and send command if pane set', function()
        -- Setup stubbed values
        local m = mock(vim.api, true)
        m.nvim_call_function.on_call_with('input', {'Enter pane to send command too: '}).returns(2)
        m.nvim_call_function.on_call_with('input', {'Enter command: '}).returns('pwd')
        stub(testModule, 'execute_user_command')

        -- call capture function
        testModule.send_one_off_command_to_pane()

        assert.stub(m.nvim_call_function).was_called_with('input', {'Enter command: '})
        assert.stub(testModule.execute_user_command).was_called_with('pwd')

        mock.revert(m)
      end)
    end)

    describe('scroll', function()
      it('Should scroll up', function()
        -- Setup stubbed values
        local m = mock(vim.api, true)
        m.nvim_call_function.on_call_with('input', {'Enter pane to send command too: '}).returns(2)
        stub(os, 'execute')

        testModule.scroll(true)

        -- assert execute called
        assert.stub(os.execute).was_called_with('tmux if-shell -F -t "2" "#{pane_in_mode}" "" "copy-mode"')
        assert.stub(os.execute).was_called_with('tmux send-keys -t "2" -X halfpage-up')

        -- reset stubs
        os.execute:revert()
      end)

      it('Should scroll down', function()
        -- Setup stubbed values
        local m = mock(vim.api, true)
        m.nvim_call_function.on_call_with('input', {'Enter pane to send command too: '}).returns(2)
        stub(os, 'execute')

        testModule.scroll(false)

        -- assert execute called
        assert.stub(os.execute).was_called_with('tmux if-shell -F -t "2" "#{pane_in_mode}" "" "copy-mode"')
        assert.stub(os.execute).was_called_with('tmux send-keys -t "2" -X halfpage-down')

        -- reset stubs
        os.execute:revert()
      end)
    end)
  end)
end)
