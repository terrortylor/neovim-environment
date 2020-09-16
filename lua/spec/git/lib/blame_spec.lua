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

      describe('create_window', function()
        it('Should create window with expected values, and mappings', function()
          local m = mock(vim.api, true)
          m.nvim_create_buf.returns(101)
          local m_getn = stub(table, 'getn')
          m_getn.returns(2)

          local lines = {
            "this lines has 28 charecters",
            "this is just another line"
          }
          local mappings = {
            "<ESC>",
            "<CR>"
          }

          testModule.create_window(lines, 5, 4, mappings)

          -- buffer created with expected lines
          assert.stub(m.nvim_buf_set_lines).was_called_with(101, 0, -1, true, lines)
          -- mappings created to close window with
          assert.stub(m.nvim_buf_set_keymap).was_called_with(101, "n", "<ESC>", "<CMD>lua require('git.lib.blame').close_window()<CR>", { noremap = true })
          assert.stub(m.nvim_buf_set_keymap).was_called_with(101, "n", "<CR>", "<CMD>lua require('git.lib.blame').close_window()<CR>", { noremap = true })

          local opts = {
            style = "minimal",
            row = -1,
            col = 0,
            width = 28, -- max line width
            height = 2, -- number of lines
            relative = "win",
            bufpos = {5, 4}, -- passed parameters
            focusable = false
          }
          assert.stub(m.nvim_open_win).was_called_with(101, true, opts)
        end)
      end)

      describe('go', function()
        it('Should not call create_window if window already exists', function()
          local m = mock(vim.api, true)
          testModule._set_window_id(1)

	  testModule.go(1, 3, {"<ESC>", "<C-x>"})
	
	  assert.stub(m.nvim_call_function).was_not_called()
        end)

        it('Should call create_window with expected values', function()
          local m = mock(vim.api, true)
          testModule._set_window_id(nil)
	  local blame_lines = [[
c21aa714 (dave.smith 2020-09-03 14:40:48 +0100 1) some line
c21aa714 (dave.smith 2020-09-03 14:40:48 +0100 2) some other line
	  ]]
          stub(testModule, "get_blame_results").returns(blame_lines)
          stub(testModule, "create_window")
	  spy.on(testModule, "convert_and_format_result")
          m.nvim_call_function.on_call_with("expand", {"%:p"}).returns("/some/file.txt")
	  m.nvim_win_get_cursor.returns({3,5})


	  testModule.go(1, 3, {"<ESC>", "<C-x>"})
	
	  local buf_lines = {"dave.smith 2020-09-03 14:40:48 c21aa714", "dave.smith 2020-09-03 14:40:48 c21aa714"}
	  assert.stub(testModule.get_blame_results).was_called_with("/some/file.txt", 1, 3)
	  assert.stub(testModule.convert_and_format_result).was_called_with(blame_lines)
	  assert.stub(testModule.create_window).was_called_with(buf_lines, 1, 5, {"<ESC>", "<C-x>"})

          mock.revert(m)
        end)

        it('Should not call create_window if no blame results returned', function()
          local m = mock(vim.api, true)
          testModule._set_window_id(nil)
          stub(testModule, "get_blame_results").returns(nil)
	  spy.on(testModule, "convert_and_format_result")
          m.nvim_call_function.on_call_with("expand", {"%:p"}).returns("/some/file.txt")
	  stub(_G, 'print')


	  testModule.go(1, 3, {"<ESC>", "<C-x>"})
	
	  assert.stub(testModule.get_blame_results).was_called_with("/some/file.txt", 1, 3)
	  assert.stub(testModule.convert_and_format_result).was_called_with(nil)
	  assert.stub(_G.print).was_called_with("GitBlame: File not tracked")

          mock.revert(m)
	  _G.print:revert()
        end)
      end)
    end)
  end)
end)
