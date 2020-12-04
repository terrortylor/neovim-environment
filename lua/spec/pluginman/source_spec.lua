-- TODO write tests
--local testModule
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
--      testModule = require('pluginman.source')
    end)


    teardown(function()
      _G._TEST = nil
    end)

    describe('go', function()
    end)
--
--    describe('get_git_args', function()
--      it('Should build git clone arg list', function()
--        local plugin = {
--          name = 'plugin/stuff'
--        }
--
--        local args = testModule._get_git_args(plugin)
--
--        local expected = {
--          'clone', '--single-branch',
--          'https://github.com/plugin/stuff.git',
--          '/nvim/config/site/pack/plugins/start/stuff'
--        }
--        assert.same(expected, args)
--      end)
--
--      it('Should build git clone arg list with branch', function()
--        local plugin = {
--          name = 'plugin/stuff',
--          branch = 'rc1.0.1'
--        }
--
--        local args = testModule._get_git_args(plugin)
--
--        local expected = {
--          'clone', '--single-branch',
--          '-b', 'rc1.0.1',
--          'https://github.com/plugin/stuff.git',
--          '/nvim/config/site/pack/plugins/start/stuff'
--        }
--        assert.same(expected, args)
--      end)
--    end)
  end)
end)
