describe('util', function()
  describe('lib', function()
    describe('table', function()
      setup(function()
        testModule = require('util.lib.table')
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
end)
