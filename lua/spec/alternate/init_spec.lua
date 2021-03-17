local testModule
local api
local mock = require('luassert.mock')
local stub = require('luassert.stub')

describe('alternate', function()

  before_each(function()
    testModule = require('alternate')
    api = mock(vim.api, true)
  end)

  after_each(function()
    mock.revert(api)
  end)

  describe('get_alternate_file', function()
    local rules = {
      code = {
        {
          condition = "code$",
          direction = "_test.code$",
          transformers = {
            {".code", "_test.code"},
            {"src/", "test/"}
          }
        }
      }
    }

    it('Should print message and return if filetype not found', function()
      testModule.rules = rules
      stub(_G, 'print')
      api.nvim_buf_get_option.on_call_with(0, 'filetype').returns('cats')
      testModule.get_alternate_file()

      assert.stub(_G.print).was_called_with('No alternate file rule found for filetype: cats')
      assert.stub(api.nvim_command).was_not_called()

      -- reset stubs
      print:revert()
    end)

    it('Should return silently if condition not matched', function()
      testModule.rules = rules
      stub(_G, 'print')
      stub(testModule, 'transform_path')
      api.nvim_buf_get_option.on_call_with(0, 'filetype').returns('code')
      api.nvim_call_function.on_call_with("expand", {"%:p"}).returns('assets/file.jpeg')

      testModule.get_alternate_file()

      assert.stub(_G.print).was_not_called_with('No alternate file rule found for filetype: cats')
      -- FIXME this doesn't work, need to extend table with metatable I thin
      assert.stub(testModule.transform_path).was_not_called()
      assert.stub(api.nvim_command).was_not_called()

      -- reset stubs
      print:revert()
      testModule.transform_path:revert()
    end)

    it('Should try to open expected alternate file', function()
      testModule.rules = rules
      stub(_G, 'print')
      api.nvim_buf_get_option.on_call_with(0, 'filetype').returns('code')
      api.nvim_call_function.on_call_with("expand", {"%:p"}).returns('src/module/funcs.code')

      testModule.get_alternate_file()

      assert.stub(_G.print).was_not_called_with('No alternate file rule found for filetype: cats')
      assert.stub(api.nvim_command).was_called_with("e test/module/funcs_test.code")

      -- reset stubs
      print:revert()
    end)

    it('Should try to open expected file from alternate file', function()
      testModule.rules = rules
      stub(_G, 'print')
      api.nvim_buf_get_option.on_call_with(0, 'filetype').returns('code')
      api.nvim_call_function.on_call_with("expand", {"%:p"}).returns('test/module/funcs_test.code')

      testModule.get_alternate_file()

      assert.stub(_G.print).was_not_called_with('No alternate file rule found for filetype: cats')
      assert.stub(api.nvim_command).was_called_with("e src/module/funcs.code")

      -- reset stubs
      print:revert()
    end)
  end)

  describe('transform_path', function()
    local transformers = {
      -- TODO add % before . busted throws error, differences in lua?
      {".code", "_test.code"},
      {"src/",  "test/"}
    }

    it('Should transfor path from file to alternate file', function()
      local result = testModule.transform_path("src/package/core.code", transformers, true)

      assert.are.equal("test/package/core_test.code", result)
    end)

    it('Should transfor path from alternate file to file', function()
      local result = testModule.transform_path("test/package/core_test.code", transformers, false)

      assert.are.equal("src/package/core.code", result)
    end)
  end)
end)
