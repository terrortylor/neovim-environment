-- luacheck: ignore
--require('busted')
require('lfs')
--require('busted.runner')({output='gtest'}, 3)
require('busted.runner')

describe("simple test", function()
  it("Should assert", function()
    assert.equals(true, true)
  end)
end)
