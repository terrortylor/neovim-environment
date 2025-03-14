local ts = vim.treesitter

local function find_or_insert_header(header_prefix, header_text, add_to_top)
  print("1")
  local bufnr = vim.api.nvim_get_current_buf()
  local parser = ts.get_parser(bufnr, "markdown")
  local tree = parser:parse()[1]
  local root = tree:root()
  local line_header_text = header_prefix .. " " .. header_text

  local query = '(atx_heading (inline) @header (#eq? @header "'.. header_text ..'"))'


  local found = false
  for id, node, _ in ts.query.parse("markdown", query):iter_captures(root, bufnr) do
    local start_row, _, end_row, _ = node:range()
    local lines = vim.api.nvim_buf_get_lines(bufnr, start_row, end_row + 1, false)
    
    if lines[1] == line_header_text then
      vim.api.nvim_win_set_cursor(0, {start_row + 1, 0}) -- Move cursor to found header
      found = true
  print("2")
    end

-- Create a user command to add a tag
    -- there should only ever be one node that matches
      break
  end

  -- If the header does not exist, insert it at the top and move the cursor there
  if not found then
    if add_to_top then
      vim.api.nvim_buf_set_lines(bufnr, 0, 0, false, {line_header_text, ""})
      vim.api.nvim_win_set_cursor(0, {1, 0})
    else
  print("3")
      local line_count = vim.api.nvim_buf_line_count(bufnr)
      vim.api.nvim_buf_set_lines(bufnr, line_count, line_count, false, {line_header_text, ""})
      vim.api.nvim_win_set_cursor(0, {line_count + 1, 0})
    end
  end
  
  return found
end


-- Function to add a tag under the "tags" header
local function add_tag_under_header(header_prefix, header_text, add_to_top)
  -- Prompt the user for a tag value
  vim.ui.input({ prompt = "Enter tag: " }, function(input)
    print("input:"..input)
    if not input or input == "" then
      print("1 1")
      return
    end

    print("1 2")
    -- Find or create the "tags" header and position cursor below it
    find_or_insert_header(header_prefix, header_text, add_to_top)

    print("1 3")
    local bufnr = vim.api.nvim_get_current_buf()
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    local current_line_num = cursor_pos[1] - 1  -- Convert to 0-indexed

    -- Get the current line
    local current_line = vim.api.nvim_buf_get_lines(bufnr, current_line_num, current_line_num + 1, false)[1]

    input = "- #"..input
    -- If the current line is not empty, move to the next line
    if current_line ~= "" then
      -- Insert a new line after the current position
      vim.api.nvim_buf_set_lines(bufnr, current_line_num + 1, current_line_num + 1, false, {input})
      -- Move cursor to the new line
      vim.api.nvim_win_set_cursor(0, {current_line_num + 2, 0})
    else
      -- Replace the empty line with the tag
      vim.api.nvim_buf_set_lines(bufnr, current_line_num, current_line_num + 1, false, {input})
      -- Keep cursor at the same line
      vim.api.nvim_win_set_cursor(0, {current_line_num + 1, 0})
    end
  end)
end

local function insert_attendee()
  add_tag_under_header("#", "Attendees", false)
end
vim.api.nvim_create_user_command("AddAttendee", insert_attendee, {})

local function insert_attendee()
  add_tag_under_header("#", "Tags", false)
end
vim.api.nvim_create_user_command("AddTag", insert_attendee, {})
