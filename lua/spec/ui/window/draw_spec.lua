local testModule
local api
local mock = require("luassert.mock")
local stub = require("luassert.stub")

describe("ui.window.draw", function()
  before_each(function()
    testModule = require("ui.window.draw")
    api = mock(vim.api, true)
  end)

  after_each(function()
    mock.revert(api)
  end)

  describe("get_split_command", function()
    it("Should top side split command", function()
      local actual = testModule.get_split_command("top")

      assert.equal("topleft split", actual)
    end)

    it("Should bottom side split command", function()
      local actual = testModule.get_split_command("bottom")

      assert.equal("botright split", actual)
    end)

    it("Should left side split command", function()
      local actual = testModule.get_split_command("left")

      assert.equal("vertical topleft split", actual)
    end)

    it("Should return default right split command if right or anything else", function()
      local actual = testModule.get_split_command("right")

      assert.equal("vertical botright split", actual)
    end)

    -- TODO add test that takes size into account
  end)

  describe("open_draw", function()
    it("Should open draw with expected split command and then open target buffer", function()
      stub(vim, "cmd")
      api.nvim_get_current_win.returns(101)

      testModule.open_draw(5, "left", "")
      local actual = testModule.toggled_bufs[5]

      assert.stub(vim.cmd).was_called_with("vertical topleft split")
      assert.stub(vim.cmd).was_called_with("buffer 5")
      assert.are_not.equals(nil, actual)
      assert.equals(101, actual.win)
      assert.equals("", actual.size)
      assert.equals("left", actual.position)
    end)

    it("Should do nothing is window already open", function()
      stub(vim, "cmd")
      local actual = testModule.toggled_bufs[5]
      assert.equals(101, actual.win)

      testModule.open_draw(5, "left", "")

      assert.stub(vim.cmd).was_not_called()
      assert.stub(vim.cmd).was_not_called()
      assert.are_not.equals(nil, actual)
      assert.equals(101, actual.win)
      assert.equals("", actual.size)
      assert.equals("left", actual.position)
    end)

    it("Should open draw with set size", function()
      stub(vim, "cmd")
      api.nvim_get_current_win.returns(101)

      testModule.open_draw(2, "left", "40")
      local actual = testModule.toggled_bufs[2]

      assert.stub(vim.cmd).was_called_with("vertical topleft 40split")
      assert.stub(vim.cmd).was_called_with("buffer 2")
      assert.are_not.equals(nil, actual)
      assert.equals(101, actual.win)
      assert.equals("40", actual.size)
      assert.equals("left", actual.position)
    end)
  end)

  describe("close_draw", function()
    it("Should not close draw if not open", function()
      testModule.close_draw(999)

      assert.stub(api.nvim_win_close).was_not_called()
    end)

    it("Should close draw if one open", function()
      api.nvim_get_current_win.returns(101)

      testModule.open_draw(999, "left", "40")
      testModule.close_draw(999)

      assert.stub(api.nvim_win_close).was_called()

      local actual = testModule.toggled_bufs[999]
      assert.are_not.equals(nil, actual)
      assert.equals(nil, actual.win)
      assert.equals("40", actual.size)
      assert.equals("left", actual.position)
    end)
  end)

  describe("toggle", function()
    it("Should open and create props if not exists", function()
      local actual = testModule.toggled_bufs[50]
      assert.equals(nil, actual)
      api.nvim_get_current_win.returns(101)

      testModule.toggle(50, "left")
      actual = testModule.toggled_bufs[50]
      assert.are_not.equals(nil, actual)
      assert.equals(101, actual.win)
      assert.equals(nil, actual.size)
      assert.equals("left", actual.position)
    end)

    it("Should toggle close and toggle open", function()
      local actual = testModule.toggled_bufs[50]
      assert.are_not.equals(nil, actual)
      api.nvim_get_current_win.returns(200)

      -- close with toggle
      testModule.toggle(50)
      assert.equals(nil, actual.win)
      assert.equals(nil, actual.size)
      assert.equals("left", actual.position)

      -- open with toggle
      testModule.toggle(50, "left")
      actual = testModule.toggled_bufs[50]
      assert.are_not.equals(nil, actual)
      assert.equals(200, actual.win)
      assert.equals(nil, actual.size)
      assert.equals("left", actual.position)
    end)

    it("Should toggle open and toggle close", function()
      local actual = testModule.toggled_bufs[12]
      assert.equals(nil, actual)
      api.nvim_get_current_win.returns(200)

      -- open with toggle
      testModule.toggle(12, "left")
      actual = testModule.toggled_bufs[12]
      assert.equals(200, actual.win)
      assert.equals(nil, actual.size)
      assert.equals("left", actual.position)

      -- close with toggle
      testModule.toggle(12, "left")
      actual = testModule.toggled_bufs[12]
      assert.are_not.equals(nil, actual)
      assert.equals(nil, actual.win)
      assert.equals(nil, actual.size)
      assert.equals("left", actual.position)
    end)
  end)
end)
