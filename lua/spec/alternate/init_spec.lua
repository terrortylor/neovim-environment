local testModule

describe('alternate', function()
  setup(function()
    _G._TEST = true
    _G.vim = {
      api = require('spec.vim_api_helper')
    }
    testModule = require('alternate')
  end)

  teardown(function()
    _G._TEST = nil
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
    testModule.rules = rules

    it('Should print message and return if filetype not found', function()
      local m = mock(vim.api, true)
      stub(_G, 'print')
      m.nvim_buf_get_option.on_call_with(0, 'filetype').returns('cats')
      testModule.get_alternate_file()

      assert.stub(_G.print).was_called_with('No alternate file rule found for filetype: cats')
      assert.stub(m.nvim_command).was_not_called()

      -- reset stubs
      mock.revert(m)
      print:revert()
    end)

    it('Should return silently if condition not matched', function()
      local m = mock(vim.api, true)
      stub(_G, 'print')
      stub(testModule, '_transform_path')
      m.nvim_buf_get_option.on_call_with(0, 'filetype').returns('code')
      m.nvim_call_function.on_call_with("expand", {"%:p"}).returns('assets/file.jpeg')

      testModule.get_alternate_file()

      assert.stub(_G.print).was_not_called_with('No alternate file rule found for filetype: cats')
      -- FIXME this doesn't work, need to extend table with metatable I thin
      assert.stub(testModule._transform_path).was_not_called()
      assert.stub(m.nvim_command).was_not_called()

      -- reset stubs
      mock.revert(m)
      print:revert()
      testModule._transform_path:revert()
    end)

    it('Should try to open expected alternate file', function()
      local m = mock(vim.api, true)
      -- stub(_G, 'print')
      m.nvim_buf_get_option.on_call_with(0, 'filetype').returns('code')
      m.nvim_call_function.on_call_with("expand", {"%:p"}).returns('src/module/funcs.code')

      testModule.get_alternate_file()

      -- assert.stub(_G.print).was_not_called_with('No alternate file rule found for filetype: cats')
      assert.stub(m.nvim_command).was_called_with("e test/module/funcs_test.code")

      -- reset stubs
      mock.revert(m)
      -- print:revert()
    end)

    it('Should try to open expected file from alternate file', function()
      local m = mock(vim.api, true)
      -- stub(_G, 'print')
      m.nvim_buf_get_option.on_call_with(0, 'filetype').returns('code')
      m.nvim_call_function.on_call_with("expand", {"%:p"}).returns('test/module/funcs_test.code')

      testModule.get_alternate_file()

      -- assert.stub(_G.print).was_not_called_with('No alternate file rule found for filetype: cats')
      assert.stub(m.nvim_command).was_called_with("e src/module/funcs.code")

      -- reset stubs
      mock.revert(m)
      -- print:revert()
    end)
  end)

  describe('transform_path', function()
    local transformers = {
      -- TODO add % before . busted throws error, differences in lua?
      {".code", "_test.code"},
      {"src/",  "test/"}
    }

    it('Should transfor path from file to alternate file', function()
      local result = testModule._transform_path("src/package/core.code", transformers, true)

      assert.are.equal("test/package/core_test.code", result)
    end)

    it('Should transfor path from alternate file to file', function()
      local result = testModule._transform_path("test/package/core_test.code", transformers, false)

      assert.are.equal("src/package/core.code", result)
    end)
  end)
end)
