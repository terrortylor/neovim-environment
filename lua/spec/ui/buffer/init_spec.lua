local testModule = require('ui.buffer')
local api
local mock = require('luassert.mock')

describe('ui.buffer', function()

  before_each(function()
    api = mock(vim.api, true)
  end)

  after_each(function()
    mock.revert(api)
  end)

  describe('new_line_no_comment', function()
    it('Should set empty line above current line', function()
      api.nvim_win_get_cursor.on_call_with(0).returns({6, 12})

      testModule.new_line_no_comment(true)

      assert.stub(api.nvim_buf_set_lines).was_called_with(0, 5, 5, 0, {""})
    end)

    it('Should set empty line below current line', function()
      api.nvim_win_get_cursor.on_call_with(0).returns({6, 12})

      testModule.new_line_no_comment(false)

      assert.stub(api.nvim_buf_set_lines).was_called_with(0, 6, 6, 0, {""})
    end)
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

  describe('prototype', function()
    it('Should reset mark position on no error', function()
      -- Setup stubbed values
      api.nvim_buf_get_mark.on_call_with(0, "a").returns({9, 12})

      testModule.prototype()

      assert.stub(api.nvim_call_function).was_called_with("setpos", {"'a", {0, 9, 12, 0}})

    end)

    it('Should reset mark position on error', function()
      -- TODO busted/luassert doesn't seem to handle stubbing a method to throw an error
    end)
  end)
end)
