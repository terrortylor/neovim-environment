local lines = {
  " - [ ] item 1",
  " - [ ] item 2",
  " - [ ] item 3",
}

describe("todo_lists", function()
  it("Should toggle checkboxes", function()
    local expected_done = {
      " - [ ] item 1",
      " - [x] item 2",
      " - [ ] item 3",
    }
    local expected_started = {
      " - [ ] item 1",
      " - [o] item 2",
      " - [ ] item 3",
    }
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(buf, 'filetype', 'markdown')
    vim.api.nvim_command("sbuffer " .. buf)

    vim.api.nvim_buf_set_lines(0, 0, -1, true, lines)

    -- local map = vim.api.nvim_command_output("verbose nmap <leader>md")
    -- map = "m- " .. map:gsub("\n", " ")
    -- local out = vim.api.nvim_command_output("set filetype?")
    -- print("out is ", out)
    -- print("map is ", map)
    -- print("wtf")

    -- -- go to top of file first?
    -- -- go to cursor
    -- vim.api.nvim_command("search('|', 'c')")
    -- -- remove cursor
    -- -- vim.api.nvim_command("substitute(getline('.'), '|', '', '')")
    -- vim.api.nvim_command("normal .s/|//")

    vim.api.nvim_win_set_cursor(0, {2,0})
    vim.api.nvim_feedkeys(" md", "x", false)

    local result = vim.api.nvim_buf_get_lines(
    0, 0, vim.api.nvim_buf_line_count(0), false
    )
    assert.are.same(expected_done, result)

    vim.api.nvim_win_set_cursor(0, {2,0})
    vim.api.nvim_feedkeys(" ms", "x", false)

    local result = vim.api.nvim_buf_get_lines(
    0, 0, vim.api.nvim_buf_line_count(0), false
    )
    assert.are.same(expected_started, result)
  end)

  it("Should handle o", function()
    local expected = {
      " - [ ] item 1",
      " - [ ] item 2",
      " - [ ] new item",
      " - [ ] item 3",
    }
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(buf, 'filetype', 'markdown')
    vim.api.nvim_command("sbuffer " .. buf)

    vim.api.nvim_buf_set_lines(0, 0, -1, true, lines)


    vim.api.nvim_win_set_cursor(0, {2,0})
    vim.api.nvim_feedkeys("onew item", "x", false)

    local result = vim.api.nvim_buf_get_lines(
    0, 0, vim.api.nvim_buf_line_count(0), false
    )
    assert.are.same(expected, result)
  end)

  it("Should handle O", function()
    local expected = {
      " - [ ] item 1",
      " - [ ] new item",
      " - [ ] item 2",
      " - [ ] item 3",
    }
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(buf, 'filetype', 'markdown')
    vim.api.nvim_command("sbuffer " .. buf)

    vim.api.nvim_buf_set_lines(0, 0, -1, true, lines)


    vim.api.nvim_win_set_cursor(0, {2,0})
    vim.api.nvim_feedkeys("Onew item", "x", false)

    local result = vim.api.nvim_buf_get_lines(
    0, 0, vim.api.nvim_buf_line_count(0), false
    )
    assert.are.same(expected, result)
  end)
end)
