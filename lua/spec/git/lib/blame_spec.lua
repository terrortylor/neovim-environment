describe('git', function()
  describe('lib', function()
    describe('blame', function()
      setup(function()
        _G._TEST = true
        _G.vim = {
          api = require('spec.vim_api_helper')
        }
        testModule = require('git.lib.blame')
      end)

      teardown(function()
        _G._TEST = nil
      end)

      after_each(function()
        mock.revert(m)
      end)

      describe('convert_and_format_result', function()
        it('Should convert result as expected', function()
          tests = {
            {
              input = [[
              git blame -L 1,2 init.vim
              0458bf91 nvim/config/init.vim (John Smith 2019-08-14 07:44:08 +0100 1) line 1
              234bf333 nvim/config/init.vim (Brian Grey 2019-08-14 07:55:00 +0100 1) line 2
              ]],
              output = {
                "John Smith 2019-08-14 07:44:08 0458bf91",
                "Brian Grey 2019-08-14 07:55:00 234bf333",
              }
            },
            {
              input = [[
              0458bf91 nvim/config/init.vim (John Smith 2019-08-14 07:44:08 +0100 1) line 1
              234bf333 nvim/config/init.vim (Brian Grey 2019-08-14 07:55:00 +0100 1) line 2
              ]],
              output = {
                "John Smith 2019-08-14 07:44:08 0458bf91",
                "Brian Grey 2019-08-14 07:55:00 234bf333",
              }
            },
            {
              input = [[]],
              output = {}
            },
          }

          for _, test in pairs(tests) do
            local result = testModule.convert_and_format_result(test["input"])

            assert.are.same(test["output"], result)
          end
        end)
      end)

      describe('get_blame_results', function()
        it('Should create expected blame command', function()
          local m = mock(vim.api, true)
          m.nvim_command_output.returns("some result")

          local result = testModule.get_blame_results('test.txt', 4, 6)

          assert.are.equal("some result", result)
          assert.stub(m.nvim_command_output).was_called_with('!git blame -L 4,6 test.txt')
        end)
      end)

      describe('close_window', function()
        it('Should not close window if id not set', function()
          local m = mock(vim.api, true)

          testModule.close_window()

          assert.stub(m.nvim_win_is_valid).was_not_called()
          assert.stub(m.nvim_win_close).was_not_called()
        end)

        it('Should close window if id exists and valid', function()
          local m = mock(vim.api, true)
          m.nvim_win_is_valid.returns(true)

          testModule._set_window_id(42)
          testModule.close_window()

          assert.stub(m.nvim_win_is_valid).was_called_with(42)
          assert.stub(m.nvim_win_close).was_called_with(42, true)

          mock.revert(m)
        end)

        it('Should not close window if id exists but not valid', function()
          local m = mock(vim.api, true)
          m.nvim_win_is_valid.returns(false)

          testModule._set_window_id(42)
          testModule.close_window()

          assert.stub(m.nvim_win_is_valid).was_called_with(42)
          assert.stub(m.nvim_win_close).was_not_called()

          mock.revert(m)
        end)
      end)
    end)
  end)
end)
