local testModule
local stub = require("luassert.stub")

describe("tmux.dispatch", function()
  before_each(function()
    testModule = require("tmux.dispatch")
  end)

  describe("execute", function()
    it("Should call user input local methods then send command", function()
      -- Setup stubbed values
      stub(vim, "cmd")
      stub(os, "execute")
      testModule.execute("9", "df -h")

      assert.stub(os.execute).was_called_with('tmux if-shell -F -t "9" "#{pane_in_mode}" "send-keys Escape" ""')
      assert.stub(os.execute).was_called_with('tmux send-keys -t "9" C-z "df -h" Enter')

      -- reset stubs
      os.execute:revert()
    end)

    it("Should not run escape command", function()
      -- Setup stubbed values
      stub(vim, "cmd")
      stub(os, "execute")
      testModule.execute("9", "df -h", false)

      assert.stub(os.execute).was_not_called_with('tmux if-shell -F -t "9" "#{pane_in_mode}" "send-keys Escape" ""')
      assert.stub(os.execute).was_called_with('tmux send-keys -t "9" C-z "df -h" Enter')

      -- reset stubs
      os.execute:revert()
    end)

    it("Should run wall if autowrite option set", function()
      -- todo...
    end)
  end)

  describe("scroll", function()
    it("Should scroll up", function()
      -- Setup stubbed values
      stub(os, "execute")

      testModule.scroll("2", true)

      -- assert execute called
      assert.stub(os.execute).was_called_with('tmux if-shell -F -t "2" "#{pane_in_mode}" "" "copy-mode"')
      assert.stub(os.execute).was_called_with('tmux send-keys -t "2" -X halfpage-up')

      -- reset stubs
      os.execute:revert()
    end)

    it("Should scroll down", function()
      -- Setup stubbed values
      stub(os, "execute")

      testModule.scroll("2", false)

      -- assert execute called
      assert.stub(os.execute).was_called_with('tmux if-shell -F -t "2" "#{pane_in_mode}" "" "copy-mode"')
      assert.stub(os.execute).was_called_with('tmux send-keys -t "2" -X halfpage-down')

      -- reset stubs
      os.execute:revert()
    end)
  end)
end)
