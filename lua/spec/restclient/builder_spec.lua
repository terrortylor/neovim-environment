local testModule

describe('restclient', function()
  describe('builder', function()
    setup(function()
      _G._TEST = true
      testModule = require('restclient.builder')
    end)

    teardown(function()
      _G._TEST = nil
    end)

    describe('build_url', function()
      it('Should error if any called local funcs produce error', function()
        local config = {}

       assert.has_error(function() testModule.build_curl(config) end, "URL must be provided")
      end)

      it('Should return just url in curl', function()
        local config = {url = {"goat.com"}}

        local status, result = pcall(testModule.build_curl, config)

        assert.equal(true, status)
        assert.equals('curl -X GET "goat.com"', result)
      end)

      it('Should return url and query params in curl', function()
        local config = {url = {"goat.com"}, data = {"goat=cheese"}}

        local status, result = pcall(testModule.build_curl, config)

        assert.equal(true, status)
        assert.equals('curl -X GET "goat.com?goat=cheese"', result)
      end)

      it('Should return url and data params in put curl', function()
        local config = {url = {"goat.com"}, verb = {"PUT"}, data = {"goat=cheese"}}

        local status, result = pcall(testModule.build_curl, config)

        assert.equal(true, status)
        assert.equals('curl -X PUT "goat.com" --data goat=cheese', result)
      end)

      it('Should return url and data params in post curl', function()
        local config = {url = {"goat.com"}, verb = {"POST"}, data = {"goat=cheese"}}

        local status, result = pcall(testModule.build_curl, config)

        assert.equal(true, status)
        assert.equals('curl -X POST "goat.com" --data goat=cheese', result)
      end)

      it('Should return url for post curl when data is empty', function()
        local config = {url = {"goat.com"}, verb = {"POST"}}

        local status, result = pcall(testModule.build_curl, config)

        assert.equal(true, status)
        assert.equals('curl -X POST "goat.com"', result)
      end)
    end)

    describe('get_url', function()
      it('Should throw error if URL not provided', function()
        local config = {}

       assert.has_error(function() testModule._get_url(config) end, "URL must be provided")
      end)

      it('Should get the provided url', function()
        local config = {url = {"goat.com"}}

        local status, result = pcall(testModule._get_url, config)

        assert.equal(true, status)
        assert.equals('goat.com', result)
      end)
    end)

    describe('get_verb', function()
      it('Should not get verb if not provided', function()
        local config = {}

        local actual = testModule._get_verb(config)

        assert.equals('GET', actual)
      end)

      it('Should not get uppercase verb if verb provided', function()
        local config = {verb = {'delete'}}

        local actual = testModule._get_verb(config)

        assert.equals('DELETE', actual)
      end)
    end)

    describe('get_data', function()
      it('Should not get any data if not provided', function()
        local config = {}

        local actual = testModule._get_data(config, false)

        assert.equals('', actual)
      end)

      it('Should get data as file if configured', function()
        local config = {data = {"@filename"}}

        local actual = testModule._get_data(config, false)

        assert.equals('@filename', actual)
      end)

      -- This would be called from within get_url
      it('Should get data as key value pairs as query param', function()
        local config = {data = {'house=red', 'goat=cheese'}}

        local actual = testModule._get_data(config, true)

        assert.equals('goat=cheese&house=red', actual)
      end)

      it('Should get data as key value pairs', function()
        local config = {data = {'house=red', 'goat=cheese'}}

        local actual = testModule._get_data(config, false)

        assert.equals('goat=cheese&house=red', actual)
      end)
    end)
  end)
end)
