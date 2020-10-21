local testModule

describe('markdown', function()
  describe('tasks', function()
    setup(function()
      _G._TEST = true
      _G.vim = {
        api = require('spec.vim_api_helper')
      }
      testModule = require('markdown.tasks')
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

    describe('_is_line_task_item', function()
      it('Should return the task marker/prefix or an empty string', function()
        local lines = {
          ['hello'] = false,
          ['-- comment'] = false,
          ['* not task'] = false,
          ['- stadard comment'] = false,
          ['- [] close but no'] = false,
          ['* [] close but no'] = false,
          ['- [ ]'] = true,  -- check empty list item
          ['- [ ] '] = true, -- check empty list item
          ['* [ ]'] = true,  -- check empty list item
          ['* [ ] '] = true, -- check empty list item
          ['- [ ] empty task'] = true,
          ['- [o] in progress task'] = true,
          ['- [x] done task'] = true,
          ['* [ ] empty task'] = true,
          ['* [o] in progress task'] = true,
          ['* [x] done task'] = true,
          ['  - [ ] empty task'] = true,
          ['  - [o] in progress task'] = true,
          ['  - [x] done task'] = true,
          ['  * [ ] empty task'] = true,
          ['  * [o] in progress task'] = true,
          ['  * [x] done task'] = true,
        }

        for line, expected in pairs(lines) do
          local marker = testModule._is_line_task_item(line)
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
          -- check line cleared for empty task's
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

      it("Should start new line with empty task if current line non-empty task", function()
        local m = mock(vim.api, true)
        m.nvim_call_function.on_call_with('pumvisible', {}).returns(0)
        m.nvim_get_current_line.returns("* [ ] Non-empty task line")

        stub(testModule, "nvim_escaped_command")

        testModule.handle_carridge_return()
        assert.stub(m.nvim_get_current_line).was_called(1)
        assert.stub(testModule.nvim_escaped_command).was_called(1)
        assert.stub(testModule.nvim_escaped_command).was_called_with("normal! a<CR>[ ] ")

        mock.revert(m)
      end)
    end)

    describe("set_task_state", function()
      it("Should not update line if not task", function()
        local m = mock(vim.api, true)
        m.nvim_get_current_line.returns(" * note a task")

        testModule.set_task_state(" ")
        assert.stub(m.nvim_get_current_line).was_called(1)
        assert.stub(m.nvim_set_current_line).was_called(0)

        mock.revert(m)
      end)

      it("Should update line if comment", function()
        local m = mock(vim.api, true)
        m.nvim_get_current_line.returns(" * [ ] a task")

        testModule.set_task_state("x")
        assert.stub(m.nvim_get_current_line).was_called(1)
        assert.stub(m.nvim_set_current_line).was_called(1)
        assert.stub(m.nvim_set_current_line).was_called_with(" * [x] a task")

        mock.revert(m)
      end)

      it("Should not update line if task but state not valid", function()
        local m = mock(vim.api, true)
        m.nvim_get_current_line.returns(" * [ ] valid task")

        testModule.set_task_state("g")
        assert.stub(m.nvim_get_current_line).was_called(1)
        assert.stub(m.nvim_set_current_line).was_called(0)

        mock.revert(m)
      end)

      it("Should update line if task but state valid", function()
        local states = {" ", "x", "o"}

        for _, state in pairs(states) do
          local m = mock(vim.api, true)
          m.nvim_get_current_line.returns(" * [ ] valid task")

          testModule.set_task_state(state)
          assert.stub(m.nvim_get_current_line).was_called(1)
          assert.stub(m.nvim_set_current_line).was_called(1)

          mock.revert(m)
        end
      end)
    end)

    describe('insert_empty_task_box', function()
      it('Should start empty task going down', function()
        -- check going down
        stub(testModule, "buf_get_line_above_below", "- [ ] valid task line")

        local result = testModule.insert_empty_task_box(true)
        assert.are.equal('[ ] ', result)
      end)

      it('Should start empty task going up', function()
        -- -- check going up
        stub(testModule, "buf_get_line_above_below", '- [ ] valid task line')

        local result = testModule.insert_empty_task_box(false)
        assert.are.equal('[ ] ', result)
      end)
    end)
  end)
end)
