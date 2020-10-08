describe('ui', function()
  describe('window', function()
    describe('draw', function()
      local testModule
      -- TODO update other tests so m is api
      local api

      setup(function()
        _G._TEST = true
        _G.vim = {
          api = require('spec.vim_api_helper')
        }
        testModule = require('ui.window.draw')
      end)

      teardown(function()
        _G._TEST = nil
      end)

      -- TODO use before and after in other tests
      before_each(function()
        api = mock(vim.api, true)
      end)

      after_each(function()
        mock.revert(api)
      end)

      describe('_is_buf_open', function()
        it('Should return nil if buf not open in window', function()
          api.nvim_list_wins.returns({101, 102})
          api.nvim_win_get_buf.on_call_with(101).returns(100)
          api.nvim_win_get_buf.on_call_with(102).returns(100)

          local actual = testModule._is_buf_open(99)

          assert.equals(nil, actual)
        end)

        it('Should return window id if buf not open in window', function()
          api.nvim_list_wins.returns({101, 102})
          api.nvim_win_get_buf.on_call_with(101).returns(99)
          api.nvim_win_get_buf.on_call_with(102).returns(100)

          local actual = testModule._is_buf_open(99)

          assert.equals(101, actual)
        end)
      end)

      describe('_get_split_command', function()
        it('Should top side split command', function()
          local actual = testModule._get_split_command('top')

          assert.equal('topleft split', actual)
        end)

        it('Should bottom side split command', function()
          local actual = testModule._get_split_command('bottom')

          assert.equal('botright split', actual)
        end)

        it('Should left side split command', function()
          local actual = testModule._get_split_command('left')

          assert.equal('vertical topleft split', actual)
        end)

        it('Should return default right split command if right or anything else', function()
          local actual = testModule._get_split_command('right')

          assert.equal('vertical botright split', actual)
        end)

        -- TODO add test that takes size into account
      end)

      describe('open_draw', function()
        it('Should open draw with expected split command and then open target buffer', function()
        api.nvim_get_current_win.returns(101)

        local actual =  testModule._open_draw(5, 'left', "")

        assert.equal(101, actual)
        assert.stub(api.nvim_command).was_called_with('vertical topleft split')
        assert.stub(api.nvim_command).was_called_with('buffer 5')
        end)


        -- TODO add test that takes size into account
      end)

      describe('close_draw', function()
        it('Should close draw window', function()
        testModule._close_draw(101)

        assert.stub(api.nvim_set_current_win).was_called_with(101)
        assert.stub(api.nvim_command).was_called_with('close')
        end)
      end)
    end)
  end)
end)
