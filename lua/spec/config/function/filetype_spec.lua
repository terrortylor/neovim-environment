describe('config', function()
  describe('function', function()
    describe('filetype', function()
      setup(function()
        _G._TEST = true
        _G.vim = {
          api = require('spec.vim_api_helper')
        }
        testModule = require('config.function.filetype')
      end)

      teardown(function()
        _G._TEST = nil
      end)

      after_each(function()
        mock.revert(m)
      end)

      describe('open_ftplugin_file', function()
        it('Should print message if filetype not set', function()
          -- Setup stubbed values
          local m = mock(vim.api, true)
	  m.nvim_buf_get_option.on_call_with(0, "filetype").returns("")
	  stub(_G, 'print')
          m.nvim_buf_line_count.on_call_with(0).returns(0)

          testModule.open_ftplugin_file()

	  assert.stub(_G.print).was_called_with('Filetype not set')
          assert.stub(m.nvim_eval).was_not_called()

          mock.revert(m)
	  _G.print:revert()
        end)

        it('Should open filetype file if filetype set', function()
          -- Setup stubbed values
          local m = mock(vim.api, true)
	  m.nvim_buf_get_option.on_call_with(0, "filetype").returns("lua")
          m.nvim_eval.on_call_with("expand('$MYVIMRC')").returns("/home/user/.config/nvim/init.vim")

          testModule.open_ftplugin_file()

          assert.stub(m.nvim_eval).was_called()
          assert.stub(m.nvim_command).was_called_with("edit /home/user/.config/nvim/ftplugin/lua.vim")

          mock.revert(m)
        end)
      end)
    end)
  end)
end)
