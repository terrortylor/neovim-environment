-- luacheck: globals Request
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
      it('Should match base url as expected', function()
        local result, _ = testModule.parse_lines({nil})
        assert.equal(0, #result)

        local test_table = {}
        test_table['https://google.com'] = true
        test_table['http://google.com'] = true
        test_table['https://www.google.com'] = true
        test_table['http://www.google.com'] = true
        test_table['www.google.com'] = true
        test_table['google.com'] = true
        test_table['google.co.uk'] = true


        for url,actual in pairs(test_table) do
          result = testModule.parse_lines({url})

          if actual then
            assert.same(url, result[1].url)
          else
            assert.same(nil, result[1].url)
          end
        end
      end)

      it('Should skip comments lines', function()
        local lines = {
          "# comment",
          "goats.com",
          "  # comment",
          "         # comment"
        }
        local result, _ = testModule.parse_lines(lines)

        assert.same('goats.com', result[1].url)
      end)

      it('Should not match verb and path if both not provided', function()
        local lines = {
          "goats.com",
          "GET"
        }
        local result, _ = testModule.parse_lines(lines)

        assert.same(nil, result[1].verb)
        assert.same(nil, result[1].path)
      end)

      it('Should match verb and path', function()
        local lines = {
          "goats.com",
          "GET /"
        }
        local result, _ = testModule.parse_lines(lines)

        assert.same('GET', result[1].verb)
        assert.same('/', result[1].path)
      end)

      it('Should match verb and path with special chters and numbers', function()
        local lines = {
          "goats.com",
          "GET /goat-cheese_1"
        }
        local result, _ = testModule.parse_lines(lines)

        assert.same('GET', result[1].verb)
        assert.same('/goat-cheese_1', result[1].path)
      end)

      it('Should match data key values with = seperator', function()
        local lines = {
          "goats.com",
          "goat=cheese",
          "blue=tasty"
        }
        local result, _ = testModule.parse_lines(lines)

        assert.same({goat = 'cheese', blue = 'tasty'}, result[1].data)
      end)

      it('Should match data key values with : seperator', function()
        local lines = {
          "goats.com",
          "goat:cheese"
        }
        local result, _ = testModule.parse_lines(lines)

        assert.same({goat = 'cheese'}, result[1].data)
      end)

      it('Should match header', function()
        local lines = {
          "goats.com",
          "H:Accept: application/json",
          "HEAD:X-Track: goats",
          "HEADER:X-GO: hummos",
        }

        local result, _ = testModule.parse_lines(lines)

        local expected = {
          Accept = 'application/json',
          ['X-Track'] = 'goats',
          ['X-GO'] = 'hummos'
        }
        assert.same(expected, result[1].headers)
      end)

      it('should set skipSSL if matched', function()
        local lines = {
          'goat.com',
          'nothing good'
        }

        local result, _ = testModule.parse_lines(lines)
        assert.equal(false, result[1].skipSSL)

        lines = {
          'goat.com',
          'skipSSL'
        }
        result = testModule.parse_lines(lines)
        assert.equal(true, result[1].skipSSL)
      end)

      it('Should set data filename value if line begins with @', function()
        local lines = {
          'goat.com',
          'cheeselist'
        }
        local result, _ = testModule.parse_lines(lines)
        assert.equal(nil, result[1].data_filename)

        lines = {
          'goat.com',
          '@cheeselist'
        }
        result = testModule.parse_lines(lines)
        assert.equal('@cheeselist', result[1].data_filename)
      end)

      it('Should match variables key values with = seperator', function()
        local lines = {
          "var goats.com",
          "var goat=cheese",
          "var blue=tasty"
        }
        local _, variables = testModule.parse_lines(lines)

        assert.same({goat = 'cheese', blue = 'tasty'}, variables)
      end)

      it("Should match restblock and vars", function()
        local lines = {
          "www.madeup.com",
          "POST /a/path",
          "query=param",
          "another=queryparam",
          "fromvar=@house@",
          "",
          "var var1=value",
          "var var2=words"
        }

        local result, variables = testModule.parse_lines(lines)

        assert.same('www.madeup.com', result[1].url)
        assert.same('POST', result[1].verb)
        assert.same('/a/path', result[1].path)
        assert.same({query = 'param', another = 'queryparam', fromvar = "@house@"}, result[1].data)
        assert.same({var1 = "value", var2 = "words"}, variables)
      end)
    end)

    describe('update_block', function()
      it('Should not add request if URL is empty', function()
        testModule._reset()
        local req = Request:new(nil)

        testModule._add_request(req)
        local result = testModule._get_requests()

        assert.equal(0, #result)
      end)

      it('Should add request if URL is set', function()
        testModule._reset()
        local req = Request:new(nil)
        req.url = 'goats.com'

        testModule._add_request(req)
        local result = testModule._get_requests()

        assert.equal(1, #result)
      end)
    end)
  end)
end)
