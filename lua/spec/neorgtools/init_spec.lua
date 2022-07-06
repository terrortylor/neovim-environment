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
    testModule.getNeorgCurrentWorkspaceDir = function()
      return vim.env.TMPDIR
      end
  end)

  describe("nvim_escaped_command", function()

    it("Should call expected API mehtods with expected arguments", function()
      local tmpfile = vim.fn.tempname()
      local fixture = "lua/spec/neorgtools/fixtures/links.norg"
      os.execute("cp " .. fixture .. " " .. tmpfile)
      testModule.update_links_to_file({
        old_name = "/lua/spec/neorgtools/golden/fakefile",
        new_name = "/not-a-path/file"
      })
      assertGoldenAndTemp("lua/spec/neorgtools/golden/filelink.norg", tmpfile)
    end)
  end)
end)
