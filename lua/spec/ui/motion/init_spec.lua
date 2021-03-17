describe('ui.motion', function()
  local testModule
  local mock = require('luassert.mock')
  local api

  before_each(function()
    _G._TEST = true
    testModule = require('ui.motion')
    api = mock(vim.api, true)
  end)

  after_each(function()
    mock.revert(api)
  end)

  describe('compare_closest_number', function()
    local test_table = {
      ["Both nil"] = {1, nil, nil, nil},
      ["Left only"] = {3, 1, nil, 1},
      ["Right only"] = {3, nil, 6, 6},
      ["Both but left closer"] = {3, 2, 6, 2},
      ["Both but right closer"] = {8, 1, 6, 6},
    }

    for test_name,test in pairs(test_table) do
      it('Should return closest number to cursor position: ' .. test_name, function()
        local cursor = test[1]
        local left = test[2]
        local right = test[3]
        local expected = test[4]

        local result = testModule.compare_closest_number(cursor, left, right)

        assert.are.same(expected, result)
      end)
    end
  end)

  describe('char_closest_location', function()
    local test_table = {
      ["No matches"] = {'|a line of text', '(', 1, nil},
      ["Single match after"]      = {'|a line (of) text', '(', 1, 9},
      ["Single match before"]     = {'a line (o|f) text', '(', 10, 8},
      ["Multiple matches after"]  = {'a line of| (text (some other) stuff)', '(', 10, 12},
      ["Multiple matches before"] = {'a (line (|of) text', '(', 10, 9},
    }

    for test_name,test in pairs(test_table) do
      it('Should return expected cursor position when: ' .. test_name, function()
        local line = test[1]
        local char = test[2]
        local curpos = test[3]
        local expected = test[4]

        local result = testModule.char_closest_location(line, char, curpos)

        assert.are.same(expected, result)
      end)
    end
  end)

  describe('closest_location', function()
    local test_table = {
      ["No matches"] = {'|a line of text', '(', ')', 1, {nil, nil}},
      ["Match right hand side"]      = {'|a line (of) text', '(', ')', 1, {false, 9}},
      --TODO should this be swapped, so right if same?
      ["Match left hand side when same"]     = {'a line (o|f) text', '(', ')', 10, {true, 8}},
      ["Match left hand"]     = {'a (line o|f) text', '(', ')', 10, {false, 12}},
      ["Multiple matches after"]  = {'a line of| (text (some other) stuff)', '(', ')', 10, {false, 12}},
      ["Multiple matches before"] = {'a (line (|of) text', '(', ')', 10,{true, 9}},
    }

    for test_name,test in pairs(test_table) do
      it('Should return expected match position when: ' .. test_name, function()
        local line = test[1]
        local lchar = test[2]
        local rchar = test[3]
        local curpos = test[4]
        local expected = test[5]

        local resleft, rescol = testModule.closest_location(line, lchar, rchar, curpos)

        assert.are.same(expected, {resleft, rescol})
      end)
    end
  end)
end)
