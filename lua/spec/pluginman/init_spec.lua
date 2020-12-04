-- luacheck: globals Plugin
describe('pluginman', function()
  describe('init', function()
    local testModule
    local fs
    local clone -- luacheck: ignore
    local view -- luacheck: ignore

    setup(function()
      _G._TEST = true
      _G.vim = {
        api = require("spec.vim_api_helper")
      }
      testModule = require('pluginman')
      fs = mock(require("util.filesystem"), true)
      clone = mock(require("pluginman.clone"), true)
      view = mock(require("pluginman.view"), true)
    end)

    teardown(function()
      _G._TEST = nil
    end)

    describe('add', function()
      it('Should add plugin as table if just string', function()
        testModule._reset()

        local plugins = testModule._plugins()
        assert.equals(0, #plugins)

        testModule.add('tpope/somethingawesome')
        plugins = testModule._plugins()

        assert.equals(1, #plugins)
      end)

      it('Should add plugin', function()
        testModule._reset()

        local plugins = testModule._plugins()
        assert.equals(0, #plugins)

        testModule.add({'tpope/somethingawesome'})
        plugins = testModule._plugins()

        assert.equals(1, #plugins)
      end)
    end)

    describe("check_plugin_status", function()
      it("Should mark plugin as installed if path install path exists", function()
        local plugin = Plugin:new("base/path", {url = "a/path"})
        fs.is_directory.on_call_with("base/path/site/pack/plugins/start/path").returns(true)

        testModule.check_plugin_status(plugin)

        assert.equal(true, plugin.installed)
      end)
    end)
  end)
end)
