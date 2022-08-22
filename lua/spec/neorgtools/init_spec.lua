local testModule

-- helper func assert golden file and temp file are same
local function assertGoldenAndTemp(golden, temp)
  local g = vim.fn.system("diff " .. golden .. " " .. temp)
  assert.are.equal(g, "")
end

describe("markdown.tasks", function()
  before_each(function()
    -- need to ensure that the dir exists before setting TMPDIR env value
    os.execute("mkdir /tmp/tests")
    vim.env.TMPDIR = "/tmp/tests"
    testModule = require("neorgtools")
    -- stub neorg current workspace to TMPDIR
    testModule.getNeorgCurrentWorkspaceDir = function()
      return vim.env.TMPDIR
    end
  end)

  describe("neorgtools", function()
    it("Should update backlink value in files in workspace", function()
      local tmpfile = vim.fn.tempname()
      local fixture = "lua/spec/neorgtools/fixtures/links.norg"
      os.execute("cp " .. fixture .. " " .. tmpfile)
      testModule.update_links_to_file({
        old_name = "/lua/spec/neorgtools/golden/fakefile.norg",
        new_name = "/not-a-path/file",
      })
      assertGoldenAndTemp("lua/spec/neorgtools/golden/filelink.norg", tmpfile)
    end)
  end)
end)
