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
        local result = testModule.parse_lines({nil})
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
          local result = testModule.parse_lines({url})

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
        local result = testModule.parse_lines(lines)

        assert.same('goats.com', result[1].url)
      end)

      it('Should not match verb and path if both not provided', function()
        local lines = {
          "goats.com",
          "GET"
        }
        local result = testModule.parse_lines(lines)

        assert.same(nil, result[1].verb)
        assert.same(nil, result[1].path)
      end)

      it('Should match verb and path', function()
        local lines = {
          "goats.com",
          "GET /"
        }
        local result = testModule.parse_lines(lines)

        assert.same('GET', result[1].verb)
        assert.same('/', result[1].path)
      end)

      it('Should match verb and path with special chters and numbers', function()
        local lines = {
          "goats.com",
          "GET /goat-cheese_1"
        }
        local result = testModule.parse_lines(lines)

        assert.same('GET', result[1].verb)
        assert.same('/goat-cheese_1', result[1].path)
      end)

      it('Should match data key values with = seperator', function()
        local lines = {
          "goats.com",
          "goat=cheese",
          "blue=tasty"
        }
        local result = testModule.parse_lines(lines)

        assert.same({goat = 'cheese', blue = 'tasty'}, result[1].data)
      end)

      it('Should match data key values with : seperator', function()
        local lines = {
          "goats.com",
          "goat:cheese"
        }
        local result = testModule.parse_lines(lines)

        assert.same({goat = 'cheese'}, result[1].data)
      end)

      it('Should match header', function()
        local lines = {
          "goats.com",
          "H:Accept: application/json",
          "HEAD:X-Track: goats",
          "HEADER:X-GO: hummos",
        }

        local result = testModule.parse_lines(lines)

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

        local result = testModule.parse_lines(lines)
        assert.equal(false, result[1].skipSSL)

        local lines = {
          'goat.com',
          'skipSSL'
        }
        local result = testModule.parse_lines(lines)
        assert.equal(true, result[1].skipSSL)
      end)

      it('Should set data filename value if line begins with @', function()
        local lines = {
          'goat.com',
          'cheeselist'
        }
        local result = testModule.parse_lines(lines)
        assert.equal(nil, result[1].data_filename)

        local lines = {
          'goat.com',
          '@cheeselist'
        }
        local result = testModule.parse_lines(lines)
        assert.equal('@cheeselist', result[1].data_filename)
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
