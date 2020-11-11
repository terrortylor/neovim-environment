local testModule
local api_mock

describe('ui', function()
  describe('buffer', function()
    describe('comment', function()
      setup(function()
        _G._TEST = true
        _G.vim = {
          api = require('spec.vim_api_helper')
        }
        testModule = require('ui.buffer.comment')
      end)

      teardown(function()
        _G._TEST = nil
      end)

      before_each(function()
        api_mock = mock(vim.api, true)
      end)

      after_each(function()
        mock.revert(api_mock)
      end)

      describe('get_comment_wrapper', function()
        local commentstrings = {
          ['COMMENT %s'] = {'COMMENT ', ''},
          ['{% comment %}%s{% endcomment %}'] = {'{% comment %}', '{% endcomment %}'},
          ['c# %s'] = {'c# ', ''},
          ['dnl %s'] = {'dnl ', ''},
          ['NB. %s'] = {'NB. ', ''},
          ['! %s'] = {'! ', ''},
          ['#%s'] = {'#', ''},
          ['# %s'] = {'# ', ''},
          ['%%s'] = {'%', ''},
          ['% %s'] = {'% ', ''},
          ['(*%s*)'] = {'(*', '*)'},
          ['(;%s;)'] = {'(;', ';)'},
          ['**%s'] = {'**', ''},
          ['-# %s'] = {'-# ', ''},
          ['-- %s'] = {'-- ', ''},
          ['--  %s'] = {'--  ', ''},
          ['.. %s'] = {'.. ', ''},
          ['.\\"%s'] = {'.\\"', ''},
          ['/*%s*/'] = {'/*', '*/'},
          ['/* %s */'] = {'/* ', ' */'},
          ['//%s'] = {'//', ''},
          ['// %s'] = {'// ', ''},
          [':: %s'] = {':: ', ''},
          [';%s'] = {';', ''},
          ['; %s'] = {'; ', ''},
          ['; // %s'] = {'; // ', ''},
          ['<!--%s-->'] = {'<!--', '-->'},
          ['<%#%s%>'] = {'<%#', '%>'},
          ['> %s'] = {'> ', ''},
          ['      *%s'] = {'      *', ''},
          ['"%s'] = {'"', ''},
          ['(*%s*)'] = {'(*', '*)'},
        }

        for string,expected in pairs(commentstrings) do
          it('Should return comment wrapper(s) for: ' .. string, function()
            api_mock.nvim_buf_get_option.on_call_with(0, 'commentstring').returns(string)
            local left, right = testModule._get_comment_wrapper(string)

            assert.equals(left, expected[1])
            assert.equals(right, expected[2])
          end)
        end

        it('Should return nil,nil if unsuported commentstring', function()
          api_mock.nvim_buf_get_option.on_call_with(0, 'commentstring').returns('something here')
          local left, right = testModule._get_comment_wrapper('something here')

          assert.equals(left, nil)
          assert.equals(right, nil)
        end)
      end)

      describe('comment_line_decorator', function()
        local commentstrings = {
          ['COMMENT line'] = {'COMMENT ', ''},
          ['{% comment %}line{% endcomment %}'] = {'{% comment %}', '{% endcomment %}'},
          ['c# line'] = {'c# ', ''},
          ['dnl line'] = {'dnl ', ''},
          ['NB. line'] = {'NB. ', ''},
          ['! line'] = {'! ', ''},
          ['#line'] = {'#', ''},
          ['# line'] = {'# ', ''},
          ['%line'] = {'%', ''},
          ['% line'] = {'% ', ''},
          ['(*line*)'] = {'(*', '*)'},
          ['(;line;)'] = {'(;', ';)'},
          ['**line'] = {'**', ''},
          ['-# line'] = {'-# ', ''},
          ['-- line'] = {'-- ', ''},
          ['--  line'] = {'--  ', ''},
          ['.. line'] = {'.. ', ''},
          ['.\\"line'] = {'.\\"', ''},
          ['/*line*/'] = {'/*', '*/'},
          ['/* line */'] = {'/* ', ' */'},
          ['//line'] = {'//', ''},
          ['// line'] = {'// ', ''},
          [':: line'] = {':: ', ''},
          [';line'] = {';', ''},
          ['; line'] = {'; ', ''},
          ['; // line'] = {'; // ', ''},
          ['<!--line-->'] = {'<!--', '-->'},
          ['<%#line%>'] = {'<%#', '%>'},
          ['> line'] = {'> ', ''},
          ['      *line'] = {'      *', ''},
          ['"line'] = {'"', ''},
          ['(*line*)'] = {'(*', '*)'},
        }

        for expected,comment_parts in pairs(commentstrings) do
          it('Should comment line as expected: ' .. expected, function()
            local actual = testModule._comment_line_decorator('line', false, comment_parts[1], comment_parts[2])

            assert.equals(expected, actual)
          end)

          -- Just to check it doesn't add a comment it one exists
          it('Should comment line as expected with clean first: ' .. expected, function()
            local actual = testModule._comment_line_decorator(expected, true, comment_parts[1], comment_parts[2])

            assert.equals(expected, actual)
          end)
        end
      end)

      describe('uncomment_line_decorator', function()
        local commentstrings = {
          ['COMMENT line'] = {'COMMENT ', ''},
          ['{% comment %}line{% endcomment %}'] = {'{% comment %}', '{% endcomment %}'},
          ['c# line'] = {'c# ', ''},
          ['dnl line'] = {'dnl ', ''},
          ['NB. line'] = {'NB. ', ''},
          ['! line'] = {'! ', ''},
          ['#line'] = {'#', ''},
          ['# line'] = {'# ', ''},
          ['%line'] = {'%', ''},
          ['% line'] = {'% ', ''},
          ['(*line*)'] = {'(*', '*)'},
          ['(;line;)'] = {'(;', ';)'},
          ['**line'] = {'**', ''},
          ['-# line'] = {'-# ', ''},
          ['-- line'] = {'-- ', ''},
          ['--  line'] = {'--  ', ''},
          ['.. line'] = {'.. ', ''},
          ['.\\"line'] = {'.\\"', ''},
          ['/*line*/'] = {'/*', '*/'},
          ['/* line */'] = {'/* ', ' */'},
          ['//line'] = {'//', ''},
          ['// line'] = {'// ', ''},
          [':: line'] = {':: ', ''},
          [';line'] = {';', ''},
          ['; line'] = {'; ', ''},
          ['; // line'] = {'; // ', ''},
          ['<!--line-->'] = {'<!--', '-->'},
          ['<%#line%>'] = {'<%#', '%>'},
          ['> line'] = {'> ', ''},
          ['      *line'] = {'      *', ''},
          ['"line'] = {'"', ''},
          ['(*line*)'] = {'(*', '*)'},
        }

        for input,comment_parts in pairs(commentstrings) do
          it('Should uncomment line as expected: ' .. input, function()
            local actual = testModule._uncomment_line_decorator(input, comment_parts[1], comment_parts[2])

            assert.equals('line', actual)
          end)
        end
      end)

      describe('comment_toggle', function()
        it('Should add left hand side comments only on entire range', function()
          api_mock.nvim_buf_get_option.on_call_with(0, 'commentstring').returns('-- %s')
          api_mock.nvim_buf_get_lines.on_call_with(0, 0, 3, false).returns({
            "line1",
            "line2",
            "line3",
          })

          testModule.comment_toggle(1, 3)

          assert.stub(api_mock.nvim_buf_set_lines).was_called_with(0, 0, 3, false, {
            "-- line1",
            "-- line2",
            "-- line3",
          })
          assert.stub(api_mock.nvim_call_function).was_called_with('setpos', {"'<", {0, 1, 1, 0}})
          assert.stub(api_mock.nvim_call_function).was_called_with('setpos', {"'>", {0, 3, 2147483647, 0}})

        end)

        it('Should remove left hand side comments only on entire range', function()
          api_mock.nvim_buf_get_option.on_call_with(0, 'commentstring').returns('-- %s')
          api_mock.nvim_buf_get_lines.on_call_with(0, 0, 3, false).returns({
            "-- line1",
            "-- line2",
            "-- line3",
          })

          testModule.comment_toggle(1, 3)

          assert.stub(api_mock.nvim_buf_set_lines).was_called_with(0, 0, 3, false, {
            "line1",
            "line2",
            "line3",
          })
          assert.stub(api_mock.nvim_call_function).was_called_with('setpos', {"'<", {0, 1, 1, 0}})
          assert.stub(api_mock.nvim_call_function).was_called_with('setpos', {"'>", {0, 3, 2147483647, 0}})
        end)

        it('Should add comments on uncommented lines to entire range', function()
          api_mock.nvim_buf_get_option.on_call_with(0, 'commentstring').returns('-- %s')
          api_mock.nvim_buf_get_lines.on_call_with(0, 0, 3, false).returns({
            "line1",
            "-- line2",
            "line3",
          })

          testModule.comment_toggle(1, 3)

          assert.stub(api_mock.nvim_buf_set_lines).was_called_with(0, 0, 3, false, {
            "-- line1",
            "-- line2",
            "-- line3",
          })
          assert.stub(api_mock.nvim_call_function).was_called_with('setpos', {"'<", {0, 1, 1, 0}})
          assert.stub(api_mock.nvim_call_function).was_called_with('setpos', {"'>", {0, 3, 2147483647, 0}})
        end)

        it('Should add left and right hand side comments to entire range', function()
          api_mock.nvim_buf_get_option.on_call_with(0, 'commentstring').returns('(*%s*)')
          api_mock.nvim_buf_get_lines.on_call_with(0, 0, 3, false).returns({
            "line1",
            "line2",
            "line3",
          })

          testModule.comment_toggle(1, 3)

          assert.stub(api_mock.nvim_buf_set_lines).was_called_with(0, 0, 3, false, {
            "(*line1*)",
            "(*line2*)",
            "(*line3*)",
          })
          assert.stub(api_mock.nvim_call_function).was_called_with('setpos', {"'<", {0, 1, 1, 0}})
          assert.stub(api_mock.nvim_call_function).was_called_with('setpos', {"'>", {0, 3, 2147483647, 0}})
        end)

        it('Should remove left and right hand side comments to entire range', function()
          api_mock.nvim_buf_get_option.on_call_with(0, 'commentstring').returns('(*%s*)')
          api_mock.nvim_buf_get_lines.on_call_with(0, 0, 3, false).returns({
            "(*line1*)",
            "(*line2*)",
            "(*line3*)",
          })

          testModule.comment_toggle(1, 3)

          assert.stub(api_mock.nvim_buf_set_lines).was_called_with(0, 0, 3, false, {
            "line1",
            "line2",
            "line3",
          })
          assert.stub(api_mock.nvim_call_function).was_called_with('setpos', {"'<", {0, 1, 1, 0}})
          assert.stub(api_mock.nvim_call_function).was_called_with('setpos', {"'>", {0, 3, 2147483647, 0}})
        end)

        it('Should not do anything if commentstring not supported', function()
          api_mock.nvim_buf_get_option.on_call_with(0, 'commentstring').returns('whatwhat')

          testModule.comment_toggle(1, 3)

          assert.stub(api_mock.nvim_buf_get_lines).was_not_called()
          assert.stub(api_mock.nvim_buf_set_lines).was_not_called()
        end)
      end)
    end)
  end)
end)
