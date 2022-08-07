local testModule

local function setUpBuffer()
  local line = "this is a control line of length 41 chars"
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_command("buffer " .. buf)
  vim.api.nvim_buf_set_lines(0, 0, 2, false, { line })
end

local function assertCurPos(pos)
  local newPos = vim.fn.getcurpos()
  assert.are.equal(pos, newPos[3])
end

local function setCurPos(pos)
  vim.fn.setpos(".", { 0, 0, pos, 0 })
end

describe("scratch.binary-line", function()
  before_each(function()
    testModule = require("scratch.binary-line")
  end)

  describe("binary-line", function()
    it("Should not go past right most boundary", function()
      setUpBuffer()
      testModule.setStart()
      testModule.search("forward")
      assertCurPos(31)
      testModule.search("forward")
      assertCurPos(36)
      testModule.search("forward")
      assertCurPos(39)
      testModule.search("forward")
      assertCurPos(40)
      testModule.search("forward")
      assertCurPos(41)
      testModule.search("forward")
      assertCurPos(41)
    end)
    it("Should not go past left most boundary", function()
      setUpBuffer()
      testModule.setStart()
      testModule.search("backward")
      assertCurPos(11)
      testModule.search("backward")
      assertCurPos(6)
      testModule.search("backward")
      assertCurPos(3)
      testModule.search("backward")
      assertCurPos(2)
    end)

    it("Should update backlink value in files in workspace", function()
      setUpBuffer()
      testModule.setStart()
      testModule.search("forward")
      assertCurPos(31)

      testModule.search("forward")
      assertCurPos(36)

      testModule.search("backward")
      assertCurPos(34)

      testModule.search("backward")
      assertCurPos(33)

      testModule.search("backward")
      assertCurPos(32)
    end)
  end)
end)
