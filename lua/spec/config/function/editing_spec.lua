describe('config', function()
  describe('function', function()
    describe('editing', function()
      setup(function()
        _G._TEST = true
        _G.vim = {
          api = require('spec.vim_api_helper')
        }
        testModule = require('config.function.editing')
      end)

      teardown(function()
        _G._TEST = nil
      end)

      after_each(function()
        mock.revert(m)
      end)

      describe('new_line_no_comment', function()
        it('Should set empty line above current line', function()
          local m = mock(vim.api, true)
	  m.nvim_win_get_cursor.on_call_with(0).returns({6, 12})

	  testModule.new_line_no_comment(true)

	  assert.stub(m.nvim_buf_set_lines).was_called_with(0, 5, 5, 0, {""})
        end)

        it('Should set empty line below current line', function()
          local m = mock(vim.api, true)
	  m.nvim_win_get_cursor.on_call_with(0).returns({6, 12})

	  testModule.new_line_no_comment(false)

	  assert.stub(m.nvim_buf_set_lines).was_called_with(0, 6, 6, 0, {""})
        end)
      end)

      describe('prototype', function()
        it('Should reset mark position on no error', function()
          -- Setup stubbed values
          local m = mock(vim.api, true)
	  m.nvim_buf_get_mark.on_call_with(0, "a").returns({9, 12})

          testModule.prototype()

          assert.stub(m.nvim_call_function).was_called_with("setpos", {"'a", {0, 9, 12, 0}})

          mock.revert(m)
        end)

        it('Should reset mark position on error', function()
          -- TODO busted/luassert doesn't seem to handle stubbing a method to throw an error
        end)
      end)
    end)
  end)
end)
