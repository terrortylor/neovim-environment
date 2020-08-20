describe('markdown', function()
  describe('todo', function()
    setup(function()
      _G._TEST = true
      _G.vim = {
        api = require('spec.vim_api_helper')
      }
      testModule = require('markdown.todo')
    end)

    teardown(function()
      _G._TEST = nil
    end)

    after_each(function()
      mock.revert(m)
    end)

    lines = {
      ['hello'] = false,
      ['-- comment'] = false,
      ['* not todo'] = false,
      ['- stadard comment'] = false,
      ['- [] close but no'] = false,
      ['* [] close but no'] = false,
      ['- [ ] empty todo'] = true,
      ['- [o] in progress todo'] = true,
      ['- [x] done todo'] = true,
      ['* [ ] empty todo'] = true,
      ['* [o] in progress todo'] = true,
      ['* [x] done todo'] = true,
      ['  - [ ] empty todo'] = true,
      ['  - [o] in progress todo'] = true,
      ['  - [x] done todo'] = true,
      ['  * [ ] empty todo'] = true,
      ['  * [o] in progress todo'] = true,
      ['  * [x] done todo'] = true,
    }

    describe('_is_line_todo_item', function()
      it('Should return the todo marker/prefix or an empty string', function()
        for line, expected in pairs(lines) do
          local marker = testModule._is_line_todo_item(line)
          assert.are.equal(expected, marker)
        end
      end)
    end)

    describe('insert_empty_todo_box', function()
      it('Should start empty TODO', function()
        -- check going down edge case of on first line
        local m = mock(vim.api, true)
        m.nvim_win_get_cursor.returns({1, 0}) -- returns (row, col)
        m.nvim_buf_get_lines.returns({nil})

        local result = testModule.insert_empty_todo_box(true)
        assert.are.equal('', result)
        assert.stub(m.nvim_win_get_cursor).was_called(1)
        assert.stub(m.nvim_win_get_cursor).was_called_with(0)
        assert.stub(m.nvim_buf_get_lines).was_called(1)
        assert.stub(m.nvim_buf_get_lines).was_called_with(0, -1, 0, false)
        mock.revert(m)

        -- check going down
        local m = mock(vim.api, true)
        m.nvim_win_get_cursor.returns({2, 0}) -- returns (row, col)
        m.nvim_buf_get_lines.returns({'- [ ] valid TODO line'})

        local result = testModule.insert_empty_todo_box(true)
        assert.are.equal('[ ] ', result)
        assert.stub(m.nvim_win_get_cursor).was_called(1)
        assert.stub(m.nvim_win_get_cursor).was_called_with(0)
        assert.stub(m.nvim_buf_get_lines).was_called(1)
        assert.stub(m.nvim_buf_get_lines).was_called_with(0, 0, 1, false)
        mock.revert(m)

        -- check going up
        local m = mock(vim.api, true)
        m.nvim_win_get_cursor.returns({2, 0}) -- returns (row, col)
        m.nvim_buf_get_lines.returns({'- [ ] valid TODO line'})

        local result = testModule.insert_empty_todo_box(false)
        assert.are.equal('[ ] ', result)
        assert.stub(m.nvim_win_get_cursor).was_called(1)
        assert.stub(m.nvim_win_get_cursor).was_called_with(0)
        assert.stub(m.nvim_buf_get_lines).was_called(1)
        assert.stub(m.nvim_buf_get_lines).was_called_with(0, 2, 3, false)
        mock.revert(m)
      end)
    end)
  end)
end)
