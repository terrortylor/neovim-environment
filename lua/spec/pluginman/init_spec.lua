local testModule

describe('pluginman', function()
  describe('init', function()
    setup(function()
      _G._TEST = true
      _G.vim = {
        api = require('spec.vim_api_helper')
      }
      testModule = require('pluginman')
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
  end)
end)
