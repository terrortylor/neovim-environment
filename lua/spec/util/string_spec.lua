local testModule

describe('util', function()
  describe('string', function()
    setup(function()
      testModule = require('util.string')
    end)

    describe('trim_whitespace', function()
      it('Should not modify string if not leader or trailing whitespace', function()
        local result = testModule.trim_whitespace('hello')

        assert.are.equals('hello', result)
      end)

      it('Should return modified string without leading and trailing whitespace', function()
        local test_table = {
          [' hello'] = 'hello',
          ['hello '] = 'hello',
          [' hello '] = 'hello',
          ['hello mate'] = 'hello mate',
          [' hello mate'] = 'hello mate',
        }
        for input,expected in pairs(test_table) do
          local result = testModule.trim_whitespace(input)

          assert.are.equals(expected, result)
        end
      end)
    end)
  end)
end)
