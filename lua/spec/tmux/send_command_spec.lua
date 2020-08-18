describe('tmux library', function()
  describe('send_command', function()
    setup(function()
      _G._TEST = true
      _G.vim = {
        api = require('spec.vim_api_helper')
      }
      testModule = require('tmux.send_command')
    end)

    teardown(function()
      _G._TEST = nil
    end)

    after_each(function()
      mock.revert(m)
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
        testModule._capture_pane_number()

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
        testModule._capture_pane_number()

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
        testModule._execute_user_command()

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
        testModule._capture_pane_number()
        testModule._capture_user_command()

        -- call capture function
        testModule._execute_user_command()

        -- assert execute called
        assert.stub(os.execute).was_called_with('tmux send-keys -t "2" C-z "pwd" Enter')
        assert.stub(_G.print).was_not_called_with('Missing pane or command, not running')

        -- reset stubs
        os.execute:revert()
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
  end)
end)
