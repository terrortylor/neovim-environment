describe('ui', function()
  describe('arglist', function()
    local testModule
    -- TODO update other tests so m is api
    local api

    setup(function()
      _G._TEST = true
      _G.vim = {
        api = require('spec.vim_api_helper')
      }
      testModule = require('ui.arglist')
    end)

    teardown(function()
      _G._TEST = nil
    end)

    -- TODO use before and after in other tests
    before_each(function()
      api = mock(vim.api, true)
    end)

    after_each(function()
      mock.revert(api)
    end)

    describe('get_arglist', function()
      it('Should return table of arglist items', function()
        api.nvim_command_output.on_call_with('args').returns("file/path/test.md [current/file.txt]")

        local actual = testModule.get_arglist()

        local expected = {"file/path/test.md", "current/file.txt"}
        assert.are.same(expected, actual)
      end)
    end)

    describe('set_arglist', function()
      it('Should set the arglist from table, delete if args already', function()
        local args = {"file/path/test.md", "current/file.txt"}

        testModule.set_arglist(args)

        assert.stub(api.nvim_command).was_not_called_with("argdelete *")
        assert.stub(api.nvim_command).was_called_with("argadd file/path/test.md current/file.txt")
      end)

      it('Should set the arglist from table, delete if args already', function()
        api.nvim_command_output.on_call_with('args').returns("file/path/test.md")
        local args = {"file/path/test.md", "current/file.txt"}

        testModule.set_arglist(args)

        assert.stub(api.nvim_command).was_called_with("argdelete *")
        assert.stub(api.nvim_command).was_called_with("argadd file/path/test.md current/file.txt")
      end)
    end)
  end)
end)
