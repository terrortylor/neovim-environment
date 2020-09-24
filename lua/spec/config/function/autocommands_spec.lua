local testModule

describe('config', function()
  describe('function', function()
    describe('autocommands', function()
      setup(function()
        _G._TEST = true
        _G.vim = {
          api = require('spec.vim_api_helper')
        }
        testModule = require('config.function.autocommands')
      end)

      teardown(function()
        _G._TEST = nil
      end)

      describe('move_to_last_edit', function()
        it('Should not do anythng if last buffer exit line position mark is 0', function()
          -- Setup stubbed values
          local m = mock(vim.api, true)
          m.nvim_buf_get_mark.on_call_with(0, "\"").returns({0,0})
          m.nvim_buf_line_count.on_call_with(0).returns(0)

          testModule.move_to_last_edit()

          assert.stub(m.nvim_tabpage_get_win).was_not_called()
          assert.stub(m.nvim_win_set_cursor).was_not_called()

          mock.revert(m)
        end)

        it('Should not do anythng if last buffer exit line position is greater than last line', function()
          -- Setup stubbed values
          local m = mock(vim.api, true)
          m.nvim_buf_get_mark.on_call_with(0, "\"").returns({0, 4})
          m.nvim_buf_line_count.on_call_with(0).returns(3)

          testModule.move_to_last_edit()

          assert.stub(m.nvim_tabpage_get_win).was_not_called()
          assert.stub(m.nvim_win_set_cursor).was_not_called()

          mock.revert(m)
        end)

        it('Should set buffer position and center screen', function()
          -- Setup stubbed values
          local m = mock(vim.api, true)
          m.nvim_buf_get_mark.on_call_with(0, "\"").returns({2,3})
          m.nvim_buf_line_count.on_call_with(0).returns(5)
          m.nvim_tabpage_get_win.on_call_with(0).returns(4)

          testModule.move_to_last_edit()

          assert.stub(m.nvim_tabpage_get_win).was_called_with(0)
          assert.stub(m.nvim_win_set_cursor).was_called_with(4, {2,3})
          assert.stub(m.nvim_input).was_called_with("zvzz")

          mock.revert(m)
        end)
      end)
    end)
  end)
end)
