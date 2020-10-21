require('restclient.request')
local ut = require('util.table')

describe('restclient', function()
  describe('request', function()
    setup(function()
      _G._TEST = true
    end)

    teardown(function()
      _G._TEST = nil
    end)

    describe('add_data', function()
      it('Should add data', function()
        local testObj = Request:new(nil)
        assert.equal(0, ut.dict_size(testObj.data))

        testObj:add_data('goat', 'cheese')
        assert.equal(1, ut.dict_size(testObj.data))
        assert.equal('cheese', testObj.data.goat)

        testObj:add_data('food', 'milk')
        assert.equal(2, ut.dict_size(testObj.data))
        assert.equal('milk', testObj.data.food)
      end)
    end)

    describe('add_header', function()
      it('Should add data', function()
        local testObj = Request:new(nil)
        assert.equal(0, ut.dict_size(testObj.headers))

        testObj:add_header('X-Header', 'internet')
        assert.equal(1, ut.dict_size(testObj.headers))
        assert.equal('internet', testObj.headers['X-Header'])

        testObj:add_header('Other-Stuff', 'yeah')
        assert.equal(2, ut.dict_size(testObj.headers))
        assert.equal('yeah', testObj.headers['Other-Stuff'])
      end)
    end)

    describe('get_title', function()
      it('Should return title', function()
        local testObj = Request:new(nil)
        testObj.url = 'goats.com'
        testObj.verb = 'GET'
        assert.equal('GET - goats.com', testObj:get_title())
      end)
    end)

    describe('get_url', function()
      it('Should return when no path set', function()
        local testObj = Request:new(nil)
        testObj.url = 'goats.com'
        assert.equal('goats.com', testObj:get_url())
      end)

      it('Should return when path set', function()
        local testObj = Request:new(nil)
        testObj.url = 'goats.com'
        testObj.path = '/cheese'
        assert.equal('goats.com/cheese', testObj:get_url())
      end)

      it('Should return when path set but not prefixed', function()
        local testObj = Request:new(nil)
        testObj.url = 'goats.com'
        testObj.path = 'cheese'
        assert.equal('goats.com/cheese', testObj:get_url())
      end)
    end)

    describe('get_data', function()
      it('Should return empty string when nothing set', function()
        local testObj = Request:new(nil)

        local data = testObj:get_data()

        assert.equals('', data)
      end)

      it('Should return data filename', function()
        local testObj = Request:new(nil)
        testObj.data_filename = '@goats.txt'

        local data = testObj:get_data()

        assert.equals('@goats.txt', data)
      end)

      it('Should return data key value pairs without final &', function()
        local testObj = Request:new(nil)
        testObj.data = {
          booze = 'cruise',
        }

        local data = testObj:get_data()

        assert.equals('booze=cruise', data)
      end)

      -- -- FIXME map not guanrentted order
      -- it('Should return data key value pairs', function()
      --   local testObj = Request:new(nil)
      --   testObj.data = {
      --     goat = 'cheese',
      --     booze = 'cruise',
      --   }

      --   local data = testObj:get_data()

      --   assert.equals('goat=cheese&booze=cruise', data)
      -- end)
    end)

    describe('get_curl', function()
      it('Should return url and default GET verb', function()
        local testObj = Request:new(nil)
        testObj.url = 'goats.com'

        local curl = testObj:get_curl()

        assert.equals('-X GET goats.com', curl)
      end)

      it('Should return url and expected verb', function()
        local testObj = Request:new(nil)
        testObj.url = 'goats.com'
        testObj.verb = 'PUT'

        local curl = testObj:get_curl()

        assert.equals('-X PUT goats.com', curl)
      end)

      it('Should return url and expected verb', function()
        local testObj = Request:new(nil)
        testObj.url = 'goats.com'
        testObj.verb = 'PUT'

        local curl = testObj:get_curl()

        assert.equals('-X PUT goats.com', curl)
      end)

      it('Should return curl with query params', function()
        local testObj = Request:new(nil)
        testObj.url = 'goats.com'
        testObj.data = {
          goat = 'cheese'
        }

        local curl = testObj:get_curl()

        assert.equals('-X GET goats.com?goat=cheese', curl)
      end)

      it('Should return PUT curl data arguement params', function()
        local testObj = Request:new(nil)
        testObj.url = 'goats.com'
        testObj.verb = 'PUT'
        testObj.data = {
          goat = 'cheese'
        }

        local curl = testObj:get_curl()

        assert.equals('-X PUT goats.com --data goat=cheese', curl)
      end)

      it('Should return POST curl data arguement params', function()
        local testObj = Request:new(nil)
        testObj.url = 'goats.com'
        testObj.verb = 'POST'
        testObj.data = {
          goat = 'cheese'
        }

        local curl = testObj:get_curl()

        assert.equals('-X POST goats.com --data goat=cheese', curl)
      end)
    end)

    -- describe('add_result_line', function()
    --   it('Should have empty results table if not called', function()
    --     local testObj = Request:new(nil)

    --     assert.equal(0, #testObj.result)
    --     assert.same({}, testObj.result)
    --   end)

    --   it('Should have result if called', function()
    --     local testObj = Request:new(nil)
    --     testObj:add_result_line("goat")

    --     assert.equal(1, #testObj.result)
    --     assert.same({'goat'}, testObj.result)
    --   end)

    --   it('Should have results if called', function()
    --     local testObj = Request:new(nil)
    --     testObj:add_result_line("goat")
    --     testObj:add_result_line("house music")

    --     assert.equal(2, #testObj.result)
    --     assert.same({'goat', 'house music'}, testObj.result)
    --   end)
    -- end)
  end)
end)
