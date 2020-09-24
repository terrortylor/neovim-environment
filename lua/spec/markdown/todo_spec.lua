local testModule

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

    describe('nvim_escaped_command', function()
      it('Should call expected API mehtods with expected arguments', function()
        local m = mock(vim.api, true)

        testModule.nvim_escaped_command('goats')
        assert.stub(m.nvim_command).was_called(1)
        assert.stub(m.nvim_replace_termcodes).was_called(1)
        assert.stub(m.nvim_replace_termcodes).was_called_with("goats", true, false, true)
        mock.revert(m)
      end)
    end)

    describe('_is_line_todo_item', function()
      it('Should return the todo marker/prefix or an empty string', function()
        local lines = {
          ['hello'] = false,
          ['-- comment'] = false,
          ['* not todo'] = false,
          ['- stadard comment'] = false,
          ['- [] close but no'] = false,
          ['* [] close but no'] = false,
          ['- [ ]'] = true,  -- check empty list item
          ['- [ ] '] = true, -- check empty list item
          ['* [ ]'] = true,  -- check empty list item
          ['* [ ] '] = true, -- check empty list item
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

        for line, expected in pairs(lines) do
          local marker = testModule._is_line_todo_item(line)
          assert.are.equal(expected, marker)
        end
      end)
    end)

    describe('_buf_get_line_above_below', function()
      it('Should call API for line below', function()
        local m = mock(vim.api, true)
        m.nvim_win_get_cursor.returns({2, 0}) -- returns (row, col)
        m.nvim_buf_get_lines.returns({'line below'})

        local result = testModule.buf_get_line_above_below(true)
        assert.are.equal('line below', result)
        assert.stub(m.nvim_win_get_cursor).was_called(1)
        assert.stub(m.nvim_win_get_cursor).was_called_with(0)
        assert.stub(m.nvim_buf_get_lines).was_called(1)
        assert.stub(m.nvim_buf_get_lines).was_called_with(0, 0, 1, false)

        mock.revert(m)
      end)

      it('Should call API for line above', function()
        -- check going up
        local m = mock(vim.api, true)
        m.nvim_win_get_cursor.returns({2, 0}) -- returns (row, col)
        m.nvim_buf_get_lines.returns({'line above'})

        local result = testModule.buf_get_line_above_below(false)
        assert.are.equal('line above', result)
        assert.stub(m.nvim_win_get_cursor).was_called(1)
        assert.stub(m.nvim_win_get_cursor).was_called_with(0)
        assert.stub(m.nvim_buf_get_lines).was_called(1)
        assert.stub(m.nvim_buf_get_lines).was_called_with(0, 2, 3, false)

        mock.revert(m)
      end)
    end)

    describe("handle_carridge_return", function()
      it("Should carridge return if pumvisible", function()
        local m = mock(vim.api, true)
        m.nvim_call_function.on_call_with('pumvisible', {}).returns(1)

        stub(testModule, "nvim_escaped_command")

        testModule.handle_carridge_return()
        assert.stub(testModule.nvim_escaped_command).was_called(1)
        assert.stub(testModule.nvim_escaped_command).was_called_with("normal! <CR>")
        assert.stub(m.nvim_get_current_line).was_not_called()

        mock.revert(m)
      end)

      it("Should clear line and return carridge return if empty comment", function()
        local lines = {
          -- check line cleared for empty comments
          "*",
          " *",
          " * ",
          " *  ",
          "-",
          " -",
          " - ",
          " -  ",
          -- check line cleared for empty todo's
          "* [ ]",
          " * [ ]",
          " * [ ] ",
          "- [ ]",
          " - [ ]",
          " - [ ] ",
        }

        for _, line in pairs(lines) do
          local m = mock(vim.api, true)
          m.nvim_call_function.on_call_with('pumvisible', {}).returns(0)
          m.nvim_get_current_line.returns(line)

          stub(testModule, "nvim_escaped_command")

          testModule.handle_carridge_return()
          assert.stub(m.nvim_get_current_line).was_called(1)
          assert.stub(m.nvim_set_current_line).was_called(1)
          assert.stub(testModule.nvim_escaped_command).was_called(1)
          assert.stub(testModule.nvim_escaped_command).was_called_with("normal! a<CR>")

          mock.revert(m)
        end
      end)

      it("Should start new line with empty TODO if current line non-empty TODO", function()
        local m = mock(vim.api, true)
        m.nvim_call_function.on_call_with('pumvisible', {}).returns(0)
        m.nvim_get_current_line.returns("* [ ] Non-empty todo line")

        stub(testModule, "nvim_escaped_command")

        testModule.handle_carridge_return()
        assert.stub(m.nvim_get_current_line).was_called(1)
        assert.stub(testModule.nvim_escaped_command).was_called(1)
        assert.stub(testModule.nvim_escaped_command).was_called_with("normal! a<CR>[ ] ")

        mock.revert(m)
      end)
    end)

    describe("set_todo_state", function()
      it("Should not update line if not todo", function()
        local m = mock(vim.api, true)
        m.nvim_get_current_line.returns(" * note a todo")

        testModule.set_todo_state(" ")
        assert.stub(m.nvim_get_current_line).was_called(1)
        assert.stub(m.nvim_set_current_line).was_called(0)

        mock.revert(m)
      end)

      it("Should update line if comment", function()
        local m = mock(vim.api, true)
        m.nvim_get_current_line.returns(" * [ ] a todo")

        testModule.set_todo_state("x")
        assert.stub(m.nvim_get_current_line).was_called(1)
        assert.stub(m.nvim_set_current_line).was_called(1)
        assert.stub(m.nvim_set_current_line).was_called_with(" * [x] a todo")

        mock.revert(m)
      end)

      it("Should not update line if todo but state not valid", function()
        local m = mock(vim.api, true)
        m.nvim_get_current_line.returns(" * [ ] valid todo")

        testModule.set_todo_state("g")
        assert.stub(m.nvim_get_current_line).was_called(1)
        assert.stub(m.nvim_set_current_line).was_called(0)

        mock.revert(m)
      end)

      it("Should update line if todo but state valid", function()
        local states = {" ", "x", "o"}

        for _, state in pairs(states) do
          local m = mock(vim.api, true)
          m.nvim_get_current_line.returns(" * [ ] valid todo")

          testModule.set_todo_state(state)
          assert.stub(m.nvim_get_current_line).was_called(1)
          assert.stub(m.nvim_set_current_line).was_called(1)

          mock.revert(m)
        end
      end)
    end)

    describe('insert_empty_todo_box', function()
      it('Should start empty TODO going down', function()
        -- check going down
        stub(testModule, "buf_get_line_above_below", "- [ ] valid TODO line")

        local result = testModule.insert_empty_todo_box(true)
        assert.are.equal('[ ] ', result)
      end)

      it('Should start empty TODO going up', function()
        -- -- check going up
        stub(testModule, "buf_get_line_above_below", '- [ ] valid TODO line')

        local result = testModule.insert_empty_todo_box(false)
        assert.are.equal('[ ] ', result)
      end)
    end)
  end)
end)
