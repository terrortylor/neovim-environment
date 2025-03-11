local ts = vim.treesitter

local function get_current_date_header()
  -- returns <Day of week> <date of month> <Month> <year>
  -- Tuesday 11 March 2025
  return os.date("%A %d %B %Y")
end

local function find_or_insert_header()
  local bufnr = vim.api.nvim_get_current_buf()
  local parser = ts.get_parser(bufnr, "markdown")
  local tree = parser:parse()[1]
  local root = tree:root()
  local header_text = get_current_date_header()
  local line_header_text = "# " .. header_text

  local query = '(atx_heading (inline) @header (#eq? @header "'.. header_text ..'"))'


  local found = false
  for id, node, _ in ts.query.parse("markdown", query):iter_captures(root, bufnr) do
    local start_row, _, end_row, _ = node:range()
    local lines = vim.api.nvim_buf_get_lines(bufnr, start_row, end_row + 1, false)
    
    if lines[1] == line_header_text then
      vim.api.nvim_win_set_cursor(0, {start_row + 1, 0}) -- Move cursor to found header
      found = true
    end
    -- there should only ever be one node that matches
      break
  end

  -- If the header does not exist, insert it at the top and move the cursor there
  if not found then
    vim.api.nvim_buf_set_lines(bufnr, 0, 0, false, {line_header_text, ""})
    vim.api.nvim_win_set_cursor(0, {1, 0})
  end
end

vim.api.nvim_create_user_command("TodayGoToOrInsert", find_or_insert_header, {})
