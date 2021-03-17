local testModule
local api
local mock = require('luassert.mock')

describe('config.function.autocommands', function()
  before_each(function()
    testModule = require('config.function.autocommands')
    api = mock(vim.api, true)
  end)

  after_each(function()
    mock.revert(api)
  end)

  describe('move_to_last_edit', function()
    it('Should not do anythng if last buffer exit line position mark is 0', function()
      -- Setup stubbed values
      api.nvim_buf_get_mark.on_call_with(0, "\"").returns({0,0})
      api.nvim_buf_line_count.on_call_with(0).returns(0)

      testModule.move_to_last_edit()

      assert.stub(api.nvim_tabpage_get_win).was_not_called()
      assert.stub(api.nvim_win_set_cursor).was_not_called()
    end)

    it('Should not do anythng if last buffer exit line position is greater than last line', function()
      -- Setup stubbed values
      api.nvim_buf_get_mark.on_call_with(0, "\"").returns({0, 4})
      api.nvim_buf_line_count.on_call_with(0).returns(3)

      testModule.move_to_last_edit()

      assert.stub(api.nvim_tabpage_get_win).was_not_called()
      assert.stub(api.nvim_win_set_cursor).was_not_called()
    end)

    it('Should set buffer position and center screen', function()
      -- Setup stubbed values
      api.nvim_buf_get_mark.on_call_with(0, "\"").returns({2,3})
      api.nvim_buf_line_count.on_call_with(0).returns(5)
      api.nvim_tabpage_get_win.on_call_with(0).returns(4)

      testModule.move_to_last_edit()

      assert.stub(api.nvim_tabpage_get_win).was_called_with(0)
      assert.stub(api.nvim_win_set_cursor).was_called_with(4, {2,3})
      assert.stub(api.nvim_input).was_called_with("zvzz")
    end)
  end)
end)
