local testModule

describe('restclient', function()
  describe('parser', function()
    setup(function()
      _G._TEST = true
      testModule = require('restclient.parser')
    end)

    teardown(function()
      _G._TEST = nil
    end)

    describe('parse_lines', function()
      it('Should convert lines to structured table', function()
        local lines = {
          "",                            -- Empty lines indicate rest
          "url: www.test.com",           -- whitespace before and after the URL is trimmed
          "verb :delete",
          "data:cheese=goat",
          "\\    bread=brown",           -- \ indicates line break
          "\\butter=salted     ",        -- whitespace at end of line trimmed
          "   \\name=big sandwich",      -- whitespace allowed in argument though
          "",
          "  url : google.com",
          "",
          "# comment",                   -- comments start with #
          "   # another comment",
          "\t\turl: google.com",         -- allow inentation
        }
        local actual = testModule.parse_lines(lines)

        local expected = {
          {
            url = {"www.test.com"},
            verb = {"delete"},
            data = {
              "cheese=goat",
              "bread=brown",
              "butter=salted",
              "name=big sandwich",
            }
          },
          {
            url = {"google.com"},
          },
          {
            url = {"google.com"},
          },
        }

        assert.are.same(expected, actual)
      end)
    end)
  end)
end)
