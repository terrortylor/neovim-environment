local testModule

local function assertGoldenAndTemp(golden, temp)
  local g = vim.fn.system("diff " .. golden .. " " .. temp)
  assert.are.equal(g, "")
end

describe("markdown.tasks", function()
  before_each(function()
    testModule = require("neorgtools")
    testModule.getNeorgCurrentWorkspaceDir = function()
      if vim.env.TMPDIR == nil then
        return "/tmp"
      end
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
