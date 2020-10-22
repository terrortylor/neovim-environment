local testModule
local api_mock

describe('pluginman', function()
  describe('source', function()
    setup(function()
      _G._TEST = true
      _G.vim = {
        api = require('spec.vim_api_helper')
      }
    end)

    before_each(function()
      api_mock = mock(vim.api, true)
      api_mock.nvim_call_function.on_call_with('stdpath', {'data'}).returns('/nvim/config')
      testModule = require('pluginman.source')
    end)


    teardown(function()
      _G._TEST = nil
    end)

    describe('go', function()
    end)

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
          local result = testModule._get_name(input)

          assert.equal(expected, result)
        end
      end)
    end)

    describe('get_url', function()
      it('Should return clone url', function()
        local tests = {
          ['tpope/awesome'] = 'https://github.com/tpope/awesome.git',
          ['https://madeup.com/brain/goats'] = 'https://madeup.com/brain/goats',
          ['www.google.com/some/shit'] = 'www.google.com/some/shit',
        }

        for input,expected in pairs(tests) do
          local result = testModule._get_url(input)

          assert.equal(expected, result)
        end
      end)
    end)

    describe('get_install_path', function()
      it('Should return defaults path if not overrides', function()
        local plugin = {
          name = 'plugin/dostuff'
        }
        local result = testModule._get_install_path(plugin)

        assert.equal('/nvim/config/site/pack/plugins/start/dostuff', result)
      end)

      it('Should return overriden path', function()
        local plugin = {
          name = 'plugin/dostuff',
          opt = 'opt',
          package = 'visual'
        }
        local result = testModule._get_install_path(plugin)

        assert.equal('/nvim/config/site/pack/visual/opt/dostuff', result)
      end)
    end)

    describe('exists', function()
      it("Should return false if plugin doesn't exist", function()
        local plugin = {
          name = 'plugin/dostuff'
        }
      api_mock.nvim_call_function.on_call_with('isdirectory', {'/nvim/config/site/pack/plugins/start/dostuff'}).returns(0)

        local result = testModule._exists(plugin)

        assert.equals(false, result)
      end)

      it('Should return true if plugin exist', function()
        local plugin = {
          name = 'plugin/stuff'
        }
      api_mock.nvim_call_function.on_call_with('isdirectory', {'/nvim/config/site/pack/plugins/start/stuff'}).returns(1)

        local result = testModule._exists(plugin)

        assert.equals(true, result)
      end)
    end)

    describe('get_git_args', function()
      it('Should build git clone arg list', function()
        local plugin = {
          name = 'plugin/stuff'
        }

        local args = testModule._get_git_args(plugin)

        local expected = {
          'clone', '--single-branch',
          'https://github.com/plugin/stuff.git',
          '/nvim/config/site/pack/plugins/start/stuff'
        }
        assert.same(expected, args)
      end)

      it('Should build git clone arg list with branch', function()
        local plugin = {
          name = 'plugin/stuff',
          branch = 'rc1.0.1'
        }

        local args = testModule._get_git_args(plugin)

        local expected = {
          'clone', '--single-branch',
          '-b', 'rc1.0.1',
          'https://github.com/plugin/stuff.git',
          '/nvim/config/site/pack/plugins/start/stuff'
        }
        assert.same(expected, args)
      end)
    end)
  end)
end)
