local testModule
local test_pattern

describe("wiki", function()
  before_each(function()
    testModule = require("wiki")
    test_pattern = testModule.opts.link_pattern
  end)

  describe("is_wiki_file", function()
    local test_table = {
      ["not-link"] = false,
      ["not link"] = false,
      ["[[not a link]]"] = false,
      ["[[a-link]]"] = true,
    }

    for value,expected in pairs(test_table) do
      it("Should correctly match: " .. value, function()
        local actual = testModule.is_word_link(test_pattern, value)

        assert.equals(expected, actual)
      end)
    end
  end)

  describe("get_link_text", function()
    local test_table = {
      ["not-link"] = nil,
      ["not link"] = nil,
      ["[[not a link]]"] = nil,
      ["[[a-link]]"] = "a-link",
    }

    for value,expected in pairs(test_table) do
      it("Should correctly match: " .. value, function()
        local actual = testModule.get_link_text(test_pattern, value)

        assert.equals(expected, actual)
      end)
    end
  end)
end)
