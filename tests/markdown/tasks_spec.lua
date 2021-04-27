local function load_lines(lines)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(buf, 'filetype', 'markdown')
  vim.api.nvim_command("sbuffer " .. buf)

  vim.api.nvim_buf_set_lines(0, 0, -1, true, lines)

  return buf
end

local function get_lines()
  local result = vim.api.nvim_buf_get_lines(
  0, 0, vim.api.nvim_buf_line_count(0), false
  )
  return result
end

local function send_keys(keys)
  -- TODO can we use nvim_input here?
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), "x", false)
end

describe("todo_lists", function()
  local lines = {
    " - [ ] item 1",
    " - [ ] item 2",
    " - [ ] item 3",
  }

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
    load_lines(lines)

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

    local result = get_lines()
    assert.are.same(expected_done, result)

    vim.api.nvim_win_set_cursor(0, {2,0})
    vim.api.nvim_feedkeys(" ms", "x", false)

    result = get_lines()
    assert.are.same(expected_started, result)
  end)

  it("Should handle o", function()
    local expected = {
      " - [ ] item 1",
      " - [ ] item 2",
      " - [ ] new item",
      " - [ ] item 3",
    }
    load_lines(lines)

    vim.api.nvim_win_set_cursor(0, {2,0})
    vim.api.nvim_feedkeys("onew item", "x", false)

    local result = get_lines()
    assert.are.same(expected, result)
  end)

  it("Should handle O", function()
    local expected = {
      " - [ ] item 1",
      " - [ ] new item",
      " - [ ] item 2",
      " - [ ] item 3",
    }
    load_lines(lines)

    vim.api.nvim_win_set_cursor(0, {2,0})
    vim.api.nvim_feedkeys("Onew item", "x", false)

    local result = get_lines()
    assert.are.same(expected, result)
  end)
end)

describe("handle_carridge_return", function()
  local lines = {
    " - [ ] item 1",
    " - [ ] ",
    " - [ ] item 3",
    "a normal line",
  }

  it("Should return <CR> if pumvisible", function()
    local expected_lines = {
      " - [ ] item 1",
      " - [ ] it", -- TODO be nice to have ths as a selected completion, i.e. item
      " - [ ] ",
      " - [ ] ",
      " - [ ] item 3",
      "a normal line",
    }
    load_lines(lines)

    vim.api.nvim_win_set_cursor(0, {1,0})
    send_keys("oit<C-X><C-N><CR>")

    local result = get_lines()
    assert.are.same(expected_lines, result)
  end)

  it("Should insert empty task box if current line not empty task", function()
    local expected_lines = {
      " - [ ] item 1",
      " - [ ] ",
      " - [ ] ",
      " - [ ] item 3",
      "a normal line",
    }
    load_lines(lines)

    vim.api.nvim_win_set_cursor(0, {1,0})
    send_keys("A<cr>")

    local result = get_lines()
    assert.are.same(expected_lines, result)
  end)

  it("Should insert empty line if current line is empty task", function()
    local expected_lines = {
      " - [ ] item 1",
      "",
      "",
      " - [ ] item 3",
      "a normal line",
    }
    load_lines(lines)

    vim.api.nvim_win_set_cursor(0, {2,0})
    send_keys("A<CR>")

    local result = get_lines()
    assert.are.same(expected_lines, result)
  end)

  it("Should not PUM and line not task then just return <CR>", function()
    -- checks <CR> at end of line
    local expected_lines = {
      " - [ ] item 1",
      " - [ ] ",
      " - [ ] item 3",
      "a normal line",
      "",
    }
    load_lines(lines)

    vim.api.nvim_win_set_cursor(0, {4,0})
    send_keys("A<CR>")

    local result = get_lines()
    assert.are.same(expected_lines, result)

    -- checks <CR> at middle of line
    expected_lines = {
      " - [ ] item 1",
      " - [ ] ",
      " - [ ] item 3",
      "a nor",
      "mal line",
    }
    load_lines(lines)

    vim.api.nvim_win_set_cursor(0, {4,5})
    send_keys("i<CR>")

    result = get_lines()
    assert.are.same(expected_lines, result)
  end)
end)
