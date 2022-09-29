local testModule
local api
local mock = require("luassert.mock")

describe("util.buffer", function()
  before_each(function()
    testModule = require("util.buffer")
    api = mock(vim.api, true)
  end)

  after_each(function()
    mock.revert(api)
  end)

  describe("get_all_lines", function()
    it("Should call nvim_buf_get_lines with expected values", function()
      api.nvim_buf_line_count.on_call_with(100).returns(5)

      testModule.get_all_lines(100)

      assert.stub(api.nvim_buf_get_lines(100, 0, 5, false))
    end)
  end)

  describe("ignore_filetype", function()
    it("should not ignore file type", function()
      api.nvim_buf_get_option.on_call_with(0, "filetype").returns("not_matched")

      local result = testModule.ignore_filetype()

      assert.equal(false, result)
    end)
    it("should ignore file type", function()
      api.nvim_buf_get_option.on_call_with(0, "filetype").returns("packer")

      local result = testModule.ignore_filetype()

      assert.equal(true, result)
    end)
    it("should not ignore filetype, if has buffers and not matched", function()
      api.nvim_buf_get_option.on_call_with(0, "filetype").returns("norg")
      api.nvim_buf_get_name.on_call_with(0).returns("not_matched")

      local result = testModule.ignore_filetype()

      assert.equal(false, result)
    end)
    it("should ignore filetype, if has buffers and matched", function()
      api.nvim_buf_get_option.on_call_with(0, "filetype").returns("norg")
      api.nvim_buf_get_name.on_call_with(0).returns("neorg://Quick Actions")

      local result = testModule.ignore_filetype()

      assert.equal(true, result)
    end)
  end)
end)
