-- luacheck: globals Plugin
require'pluginman.plugin'

describe('pluginman', function()
  describe('plugin', function()
    local install_path = "/nvim"

    describe('get_name', function()
      it('Should give plugin name from full path', function()
        local tests = {
          ['tpope/awesome'] = 'awesome',
          ['tpope/awesome.nvim'] = 'awesome.nvim',
          ['tpope/is-awesome'] = 'is-awesome',
          ['goats/eat_ch33se'] = 'eat_ch33se',
          ['www.github.com/someone/aplugin'] = 'aplugin',
        }

        for input,expected in pairs(tests) do
          local testObj = Plugin:new(install_path, {url = input})
          local result = testObj:get_name()

          assert.equal(expected, result)
        end
      end)
    end)

    describe('get_install_path', function()
      it('Should return defaults path if not overrides', function()
        local testObj = Plugin:new(install_path, {url = 'plugin/dostuff'})
        local result = testObj:get_install_path()
        assert.equal('/nvim/site/pack/plugins/start/dostuff', result)
      end)

      it('Should return overriden path', function()
        local opts = {
          url = 'plugin/dostuff',
          package = 'visual',
          loaded = 'opt'
        }
        local testObj = Plugin:new(install_path, opts)
        local result = testObj:get_install_path()

        assert.equal('/nvim/site/pack/visual/opt/dostuff', result)
      end)
    end)

    describe("get_docs_path", function()
      it("Should return defaults path if not overrides", function()
        local testObj = Plugin:new(install_path, {url = "plugin/dostuff"})
        local result = testObj:get_docs_path()
        assert.equal("/nvim/site/pack/plugins/start/dostuff/doc", result)
      end)

      it("Should return overriden path", function()
        local opts = {
          url = "plugin/dostuff",
          package = "visual",
          loaded = "opt"
        }
        local testObj = Plugin:new(install_path, opts)
        local result = testObj:get_docs_path()

        assert.equal("/nvim/site/pack/visual/opt/dostuff/doc", result)
      end)
    end)
  end)
end)
