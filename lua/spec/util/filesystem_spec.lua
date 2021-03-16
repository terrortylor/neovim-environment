local testModule
local api
local mock = require('luassert.mock')

describe('util', function()
  describe('filesystem', function()

    before_each(function()
      testModule = require('util.filesystem')
      api = mock(vim.api, true)
    end)

    after_each(function()
      mock.revert(api)
    end)

    describe("is_directory", function()
      it("Should return true when director exists", function()
        api.nvim_call_function.on_call_with("isdirectory", {"a/path"}).returns(1)

        local actual = testModule.is_directory("a/path")

        assert.equal(true, actual)
      end)

      it("Should return true when director exists", function()
        api.nvim_call_function.on_call_with("isdirectory", {"a/path"}).returns(0)

        local actual = testModule.is_directory("a/path")

        assert.equal(false, actual)
      end)
    end)

    describe("is_file", function()
      it("Should return true when file exists", function()
        api.nvim_call_function.on_call_with("filereadable", {"a/path"}).returns(1)

        local actual = testModule.is_file("a/path")

        assert.equal(true, actual)
      end)

      it("Should return true when file exists", function()
        api.nvim_call_function.on_call_with("filereadable", {"a/path"}).returns(0)

        local actual = testModule.is_file("a/path")

        assert.equal(false, actual)
      end)
    end)
  end)
end)
