local utils = require('util.test_utils')

describe("todo_lists", function()
  local lines = [[
  - [ ] item 1
  - [ ] item 2
  - [ ] item 3
]]

  it("Should toggle checkboxes", function()
    local expected_done = [[
  - [ ] item 1
  - [x] item 2
  - [ ] item 3
]]
    local expected_started = [[
  - [ ] item 1
  - [o] item 2
  - [ ] item 3
]]
    utils.load_lines(lines)
    vim.api.nvim_buf_set_option(0 ,'filetype', 'markdown')

    vim.api.nvim_win_set_cursor(0, {2,0})
    vim.api.nvim_feedkeys(" md", "x", false)

    local result = utils.buf_as_multiline()
    assert.are.same(expected_done, result)

    vim.api.nvim_win_set_cursor(0, {2,0})
    vim.api.nvim_feedkeys(" ms", "x", false)

    result = utils.buf_as_multiline()
    assert.are.same(expected_started, result)
  end)

  it("Should handle o", function()
    local expected = [[
  - [ ] item 1
  - [ ] item 2
  - [ ] new item
  - [ ] item 3
]]
    utils.load_lines(lines)
    vim.api.nvim_buf_set_option(0 ,'filetype', 'markdown')

    vim.api.nvim_win_set_cursor(0, {2,0})
    vim.api.nvim_feedkeys("onew item", "x", false)

    local result = utils.buf_as_multiline()
    assert.are.same(expected, result)
  end)

  it("Should handle O", function()
    local expected = [[
  - [ ] item 1
  - [ ] new item
  - [ ] item 2
  - [ ] item 3
]]
    utils.load_lines(lines)
    vim.api.nvim_buf_set_option(0 ,'filetype', 'markdown')

    vim.api.nvim_win_set_cursor(0, {2,0})
    vim.api.nvim_feedkeys("Onew item", "x", false)

    local result = utils.buf_as_multiline()
    assert.are.same(expected, result)
  end)
end)

describe("handle_carridge_return", function()
  -- luacheck: ignore
  local lines = [[
  - [ ] item 1
  - [ ] 
  - [ ] item 3
  a normal line
]]

  it("Should return <CR> if pumvisible", function()
    local expected_lines = [[
  - [ ] item 1
  - [ ] it
  - [ ] 
  - [ ] 
  - [ ] item 3
  a normal line
]]
    utils.load_lines(lines)
    vim.api.nvim_buf_set_option(0 ,'filetype', 'markdown')

    vim.api.nvim_win_set_cursor(0, {1,0})
    utils.send_keys("oit<C-X><C-N><CR>")

    local result = utils.buf_as_multiline()
    assert.are.same(expected_lines, result)
  end)

  it("Should insert empty task box if current line not empty task", function()
    local expected_lines = [[
  - [ ] item 1
  - [ ] 
  - [ ] 
  - [ ] item 3
  a normal line
]]
    utils.load_lines(lines)
    vim.api.nvim_buf_set_option(0 ,'filetype', 'markdown')

    vim.api.nvim_win_set_cursor(0, {1,0})
    utils.send_keys("A<cr>")

    local result = utils.buf_as_multiline()
    assert.are.same(expected_lines, result)
  end)

  it("Should insert empty line if current line is empty task", function()
    local expected_lines = [[
  - [ ] item 1


  - [ ] item 3
  a normal line
]]
    utils.load_lines(lines)
    vim.api.nvim_buf_set_option(0 ,'filetype', 'markdown')

    vim.api.nvim_win_set_cursor(0, {2,0})
    utils.send_keys("A<CR>")

    local result = utils.buf_as_multiline()
    assert.are.same(expected_lines, result)
  end)

  it("Should not PUM and line not task then just return <CR>", function()
   -- checks <CR> at end of line
    local expected_lines = [[
  - [ ] item 1
  - [ ] 
  - [ ] item 3
  a normal line

]]
    utils.load_lines(lines)
    vim.api.nvim_buf_set_option(0 ,'filetype', 'markdown')

    vim.api.nvim_win_set_cursor(0, {4,0})
    utils.send_keys("A<CR>")

    local result = utils.buf_as_multiline()
    assert.are.same(expected_lines, result)

   -- checks <CR> at middle of line
    expected_lines = [[
  - [ ] item 1
  - [ ] 
  - [ ] item 3
  a nor
  mal line
]]
    utils.load_lines(lines)
    vim.api.nvim_buf_set_option(0 ,'filetype', 'markdown')

    vim.api.nvim_win_set_cursor(0, {4,7})
    utils.send_keys("i<CR>")

    result = utils.buf_as_multiline()
    assert.are.same(expected_lines, result)
  end)
end)
