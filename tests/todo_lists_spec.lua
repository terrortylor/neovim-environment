describe("todo_lists", function()
  it("Should toggle checkboxes", function()
    local lines = {
      " - [ ] item 1",
      " - [ ] item 2",
      " - [ ] item 3",
    }
    local expected = {
      " - [ ] item 1",
      " - [x] item 2",
      " - [ ] item 3",
    }
    vim.api.nvim_command("new")
    vim.api.nvim_command("set filetype=markdown")
    vim.api.nvim_buf_set_lines(0, 0, -1, true, lines) 

    -- -- go to top of file first?
    -- -- go to cursor
    -- vim.api.nvim_command("search('|', 'c')")
    -- -- remove cursor
    -- -- vim.api.nvim_command("substitute(getline('.'), '|', '', '')")
    -- vim.api.nvim_command("normal .s/|//")

    vim.api.nvim_win_set_cursor(0, {2,0})
    vim.api.nvim_feedkeys(" md", "t", false)

    local result = vim.api.nvim_buf_get_lines(
    0, 0, vim.api.nvim_buf_line_count(0), false
    )
    -- local result = vim.api.nvim_command("set filetype?")
    local f = "gg"
    print("goat" .. f)
    assert.are.same(expected, result)
  end)
end)
