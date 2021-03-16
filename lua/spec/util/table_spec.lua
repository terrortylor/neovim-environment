local testModule

describe('util', function()
  describe('table', function()
    before_each(function()
      testModule = require('util.table')
    end)

    describe('dict_size', function()
      it('Should return 0 for nil table', function()
        local table = nil
        local result = testModule.dict_size(table)
        assert.equal(0, result)
      end)

      it('Should return expected size', function()
        local table = {
          goat = 'cheese',
          book = 'words'
        }
        local result = testModule.dict_size(table)
        assert.equal(2, result)
      end)
    end)

    describe('find', function()
      it('Should return -1 if value not found', function()
        local result = testModule.find({"good", "list"}, "goat")

        assert.are.equals(-1, result)
      end)

      it('Should return list position if value found', function()
        local result = testModule.find({"good", "list"}, "list")

        assert.are.equals(2, result)
      end)
    end)
  end)
end)
