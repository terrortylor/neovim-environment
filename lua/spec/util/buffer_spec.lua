describe('util', function()
  describe('buffer', function()
    local testModule
    local api

    setup(function()
      _G._TEST = true
      _G.vim = {
        api = require('spec.vim_api_helper')
      }
      testModule = require('util.buffer')
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

    describe("get_all_lines", function()
      it("Should call nvim_buf_get_lines with expected values", function()
        api.nvim_buf_line_count.on_call_with(100).returns(5)

        testModule.get_all_lines(100)

        assert.stub(api.nvim_buf_get_lines(100, 0, 5, false))
      end)
    end)
  end)
end)
