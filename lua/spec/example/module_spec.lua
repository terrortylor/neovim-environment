-- import the luassert.mock module
local mock = require('luassert.mock')
local stub = require('luassert.stub')

describe("example", function()
  -- instance of module to be tested
  local testModule = require('example.module')
  -- mocked instance of api to interact with

  describe("realistic_func", function()
    it("Should make explected calls to api, fully mocked", function()
      -- mock the vim.api
      local api = mock(vim.api, true)

      -- set expectation when mocked api call made
      api.nvim_create_buf.returns(5)

      testModule.realistic_func()

      -- assert api was called with expcted values
      assert.stub(api.nvim_create_buf).was_called_with(false, true)
      -- assert api was called with set expectation
      assert.stub(api.nvim_command).was_called_with("sbuffer 5")

      -- revert api back to it's former glory
      mock.revert(api)
    end)

    it("Should mock single api call", function()
      -- capture some number of windows and buffers before
      -- running our function
      local buf_count = #vim.api.nvim_list_bufs()
      local win_count = #vim.api.nvim_list_wins()
      -- stub a single function in the api
      stub(vim.api, "nvim_command")

      testModule.realistic_func()

      -- capture some details after running out function
      local after_buf_count = #vim.api.nvim_list_bufs()
      local after_win_count = #vim.api.nvim_list_wins()

      -- why 3 not two? NO IDEA! The point is we mocked
      -- nvim_commad and there is only a single window
      assert.equals(3, buf_count)
      assert.equals(4, after_buf_count)

      -- WOOPIE!
      assert.equals(1, win_count)
      assert.equals(1, after_win_count)
    end)
  end)
end)
