local testModule
local api
local mock = require('luassert.mock')
local stub = require('luassert.stub')

describe('markdown.tasks', function()
  before_each(function()
    testModule = require('markdown.tasks')
    api = mock(vim.api, true)
  end)

  after_each(function()
    mock.revert(api)
  end)

  describe('nvim_escaped_command', function()
    it('Should call expected API mehtods with expected arguments', function()
      stub(vim, "cmd")

      testModule.nvim_escaped_command('goats')
      assert.stub(vim.cmd).was_called(1)
      assert.stub(api.nvim_replace_termcodes).was_called(1)
      assert.stub(api.nvim_replace_termcodes).was_called_with("goats", true, false, true)
    end)
  end)

  describe('is_line_task_item', function()
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
        local marker = testModule.is_line_task_item(line)
        assert.are.equal(expected, marker)
      end
    end)
  end)

  describe('_buf_get_line_above_below', function()
    it('Should call API for line below', function()
      api.nvim_win_get_cursor.returns({2, 0}) -- returns (row, col)
      api.nvim_buf_get_lines.returns({'line below'})

      local result = testModule.buf_get_line_above_below(true)
      assert.are.equal('line below', result)
      assert.stub(api.nvim_win_get_cursor).was_called(1)
      assert.stub(api.nvim_win_get_cursor).was_called_with(0)
      assert.stub(api.nvim_buf_get_lines).was_called(1)
      assert.stub(api.nvim_buf_get_lines).was_called_with(0, 0, 1, false)
    end)

    it('Should call API for line above', function()
      -- check going up
      api.nvim_win_get_cursor.returns({2, 0}) -- returns (row, col)
      api.nvim_buf_get_lines.returns({'line above'})

      local result = testModule.buf_get_line_above_below(false)
      assert.are.equal('line above', result)
      assert.stub(api.nvim_win_get_cursor).was_called(1)
      assert.stub(api.nvim_win_get_cursor).was_called_with(0)
      assert.stub(api.nvim_buf_get_lines).was_called(1)
      assert.stub(api.nvim_buf_get_lines).was_called_with(0, 2, 3, false)
    end)
  end)

  describe("handle_carridge_return", function()
    it("Should carridge return if pumvisible", function()
      api.nvim_call_function.on_call_with('pumvisible', {}).returns(1)
      api.nvim_get_current_line.returns("* [ ] Non-empty task line")

      stub(testModule, "nvim_escaped_command")

      testModule.handle_carridge_return()
      assert.stub(testModule.nvim_escaped_command).was_called(1)
      assert.stub(testModule.nvim_escaped_command).was_called_with("normal! <CR>")
      assert.stub(api.nvim_get_current_line).was_called(1)
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
        api = mock(vim.api, true)
        api.nvim_call_function.on_call_with('pumvisible', {}).returns(0)
      api.nvim_get_current_line.returns(line)
        api.nvim_win_get_cursor.returns({line, 4})

        stub(testModule, "nvim_escaped_command")

        testModule.handle_carridge_return()
        assert.stub(api.nvim_get_current_line).was_called(1)
        assert.stub(api.nvim_set_current_line).was_called(1)
        assert.stub(testModule.nvim_escaped_command).was_called(1)
        assert.stub(testModule.nvim_escaped_command).was_called_with("normal! i<CR>")

        mock.revert(api)
      end
    end)

    it("Should start new line with empty task if current line non-empty task", function()
      api.nvim_call_function.on_call_with('pumvisible', {}).returns(0)
      api.nvim_get_current_line.returns("* [ ] Non-empty task line")
      api.nvim_win_get_cursor.returns({1, 4})

      stub(testModule, "nvim_escaped_command")

      testModule.handle_carridge_return()
      assert.stub(api.nvim_get_current_line).was_called(1)
      assert.stub(testModule.nvim_escaped_command).was_called(1)
      assert.stub(testModule.nvim_escaped_command).was_called_with("normal! a<CR>[ ] ")
    end)
  end)

  describe("set_task_state", function()
    it("Should not update line if not task", function()
      api.nvim_get_current_line.returns(" * note a task")

      testModule.set_task_state(" ")
      assert.stub(api.nvim_get_current_line).was_called(1)
      assert.stub(api.nvim_set_current_line).was_called(0)
    end)

    it("Should update line if comment", function()
      api.nvim_get_current_line.returns(" * [ ] a task")

      testModule.set_task_state("x")
      assert.stub(api.nvim_get_current_line).was_called(1)
      assert.stub(api.nvim_set_current_line).was_called(1)
      assert.stub(api.nvim_set_current_line).was_called_with(" * [x] a task")
    end)

    it("Should not update line if task but state not valid", function()
      api.nvim_get_current_line.returns(" * [ ] valid task")

      testModule.set_task_state("g")
      assert.stub(api.nvim_get_current_line).was_called(1)
      assert.stub(api.nvim_set_current_line).was_called(0)
    end)

    it("Should update line if task but state valid", function()
      local states = {" ", "x", "o"}

      for _, state in pairs(states) do
        api = mock(vim.api, true)
        api.nvim_get_current_line.returns(" * [ ] valid task")

        testModule.set_task_state(state)
        assert.stub(api.nvim_get_current_line).was_called(1)
        assert.stub(api.nvim_set_current_line).was_called(1)
        mock.revert(api)
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
