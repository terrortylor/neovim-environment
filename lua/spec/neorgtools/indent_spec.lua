local testModule

local function openGolden(goldenFile)
  local tmpfile = vim.fn.tempname()
  local file = "lua/spec/neorgtools/fixtures/indent/" .. goldenFile
  os.execute("cp " .. file .. " " .. tmpfile)
  vim.api.nvim_command(":edit "..tmpfile)
  vim.api.nvim_buf_set_option(0, "filetype", "norg")
end

local function goToLineAnd(line, action)
  vim.api.nvim_win_set_cursor(0, { line, 0 })
  action()
  vim.api.nvim_command(":redraw")
end

local function assertLineIsCapture(line, expected)
  local captures = vim.treesitter.get_captures_at_position(0, line - 1, 0)
  if vim.tbl_isempty(captures) then
    local result = vim.api.nvim_buf_get_lines(0, 0, vim.api.nvim_buf_line_count(0), false)
    print("captures empty, buffer is:")
    vim.pretty_print(result)
  end
  assert.are.same(false, vim.tbl_isempty(captures))
  assert.are.same(expected, captures[1].capture)
end

describe("markdown.tasks", function()
  before_each(function()
    -- need to ensure that the dir exists before setting TMPDIR env value
    os.execute("mkdir -p /tmp/tests")
    vim.env.TMPDIR = "/tmp/tests"
    testModule = require("neorgtools.indent")
  end)

  describe("neorgtools.indent", function()
    -- TODO don't really need golden files now, update to set buf form list
    it("should change heading 1 to heading 2", function()
      openGolden("heading.norg")
      assertLineIsCapture(1, "neorg.headings.1.prefix")
      goToLineAnd(1, testModule.indent)
      assertLineIsCapture(1, "neorg.headings.2.prefix")
    end)
    it("should change heading 2 to heading 1", function()
      openGolden("heading.norg")
      assertLineIsCapture(2, "neorg.headings.2.prefix")
      goToLineAnd(2, testModule.dedent)
      assertLineIsCapture(2, "neorg.headings.1.prefix")
    end)
  end)
end)
