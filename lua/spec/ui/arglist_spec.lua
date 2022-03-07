local testModule = require("ui.arglist")
local api
local mock = require("luassert.mock")
local spy = require("luassert.spy")
local stub = require("luassert.stub")
local match = require("luassert.match")

describe("ui.arglist", function()
  before_each(function()
    api = mock(vim.api, true)
  end)

  after_each(function()
    mock.revert(api)
  end)

  describe("get_arglist", function()
    it("Should return table of arglist items", function()
      api.nvim_command_output.on_call_with("args").returns("file/path/test.md [current/file.txt]")

      local actual = testModule.get_arglist()

      local expected = { "file/path/test.md", "current/file.txt" }
      assert.are.same(expected, actual)
    end)
  end)

  describe("set_arglist", function()
    it("Should set the arglist from table, delete if args already", function()
      stub(vim, "cmd")
      local args = { "file/path/test.md", "current/file.txt" }

      testModule.set_arglist(args)

      assert.stub(vim.cmd).was_not_called_with("argdelete *")
      assert.stub(vim.cmd).was_called_with("argadd file/path/test.md current/file.txt")
    end)

    it("Should set the arglist from table, delete if args already", function()
      stub(vim, "cmd")
      api.nvim_command_output.on_call_with("args").returns("file/path/test.md")
      local args = { "file/path/test.md", "current/file.txt" }

      testModule.set_arglist(args)

      assert.stub(vim.cmd).was_called_with("argdelete *")
      assert.stub(vim.cmd).was_called_with("argadd file/path/test.md current/file.txt")
    end)
  end)

  describe("edit_args_in_buffer", function()
    it("Should create buffer and set lines to current arglist", function()
      local float = mock(require("ui.window.float"), true)
      local buffer = mock(require("util.buffer"), true)
      local orig_arg_list = { "arg1", "arg2" }
      local edited_arg_list = { "new/arg/list/line" }
      stub(testModule, "get_arglist").returns(orig_arg_list)
      stub(testModule, "set_arglist")
      api.nvim_create_buf.returns(101)
      buffer.get_all_lines.on_call_with(101).returns(edited_arg_list)
      local opts = { float = "opts", border = "double" }
      float.gen_centered_float_opts.returns(opts)
      -- dummy mock func to test callback inners
      float.open_float = function(_, _, callback)
        callback()
      end
      spy.on(float, "open_float")

      testModule.edit_args_in_buffer()

      -- test new buffer is created and sets liens to arg list
      assert.stub(api.nvim_create_buf).was_called()
      assert.stub(api.nvim_buf_set_lines).was_called_with(101, 0, 0, false, orig_arg_list)
      -- test creates popup window
      assert.stub(float.gen_centered_float_opts).was_called_with(0.8, 0.8, true)
      assert.stub(float.open_float).was_called_with(101, opts, match.is_function())
      -- test edited arg list is updated, happens in callback
      assert.stub(testModule.set_arglist).was_called_with(edited_arg_list)
      mock.revert(float)
      mock.revert(buffer)
      mock.revert(api)

      -- now a buffer exists, then calling again should set same buffer
      -- where arglist and buffer are the same
      api = mock(vim.api, true)
      float = mock(require("ui.window.float"), true)
      buffer = mock(require("util.buffer"), true)
      stub(testModule, "get_arglist").returns(edited_arg_list)
      stub(testModule, "set_arglist")
      buffer.get_all_lines.on_call_with(101).returns(edited_arg_list)
      opts = { float = "opts" }
      float.gen_centered_float_opts.returns(opts)
      -- dummy mock func to test callback inners
      float.open_float = function(_, _, callback)
        callback()
      end
      spy.on(float, "open_float")

      testModule.edit_args_in_buffer()

      -- tests doesn't set buffer lines as lists same
      assert.stub(api.nvim_buf_set_lines).was_not_called()
      -- test call back func called though
      assert.stub(testModule.set_arglist).was_called_with(edited_arg_list)

      mock.revert(float)
      mock.revert(buffer)
      mock.revert(api)

      -- now test where arg list has changed, so buffer arg list is not uptodate
      api = mock(vim.api, true)
      api.nvim_buf_line_count.returns(2)
      float = mock(require("ui.window.float"), true)
      buffer = mock(require("util.buffer"), true)
      stub(testModule, "get_arglist").returns(orig_arg_list)
      stub(testModule, "set_arglist")
      buffer.get_all_lines.on_call_with(101).returns(edited_arg_list)
      opts = { float = "opts" }
      float.gen_centered_float_opts.returns(opts)
      -- dummy mock func to test callback inners
      float.open_float = function(_, _, callback)
        callback()
      end
      spy.on(float, "open_float")

      testModule.edit_args_in_buffer()

      -- tests doesn't set buffer lines as lists same
      assert.stub(api.nvim_buf_set_lines).was_called_with(101, 0, 2, false, orig_arg_list)
      -- test call back func called though
      assert.stub(testModule.set_arglist).was_called_with(edited_arg_list)
    end)
  end)
end)
