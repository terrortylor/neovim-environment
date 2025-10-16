local ts = vim.treesitter

local function get_current_date_header()
  -- returns <Day of week> <date of month> <Month> <year>
  -- Tuesday 11 March 2025
  return os.date("%A %d %B %Y")
end

local function get_week_start_date()
  -- Get current time
  local current_time = os.time()
  
  -- Get current day of week (0 = Sunday, 1 = Monday, ..., 6 = Saturday)
  local wday = tonumber(os.date("%w", current_time))
  
  -- Calculate days to subtract to get to Monday (1)
  -- If Sunday (0), go back 6 days; if Monday (1), go back 0 days, etc.
  local days_to_monday = (wday == 0) and 6 or (wday - 1)
  
  -- Calculate Monday's timestamp
  local monday_time = current_time - (days_to_monday * 24 * 60 * 60)
  
  return monday_time
end

local function get_week_filename()
  -- Get the Monday of the current week
  local monday_time = get_week_start_date()
  
  -- Get week number based on Monday's date (ISO 8601 week number)
  local week_number = tonumber(os.date("%V", monday_time))
  
  -- Use 0-based indexing (subtract 1 from the week number)
  week_number = week_number - 1
  
  -- Get year and month from Monday's date (not today's date!)
  local year = os.date("%Y", monday_time)
  local month = os.date("%B", monday_time)
  
  -- Return filename in format: weeknumber-year-month.md
  return string.format("%02d-%s-%s.md", week_number, year, month)
end

-- Custom function to open or create the weekly journal file.
-- Note: We don't use the LSP's LspToday command because it doesn't format the filename
-- correctly according to my requirements. Specifically:
--   - The LSP uses the current date's month, not the week start date's month
--   - This causes issues when a week spans two months (e.g., week starts Oct 28, today is Nov 1)
--   - The LSP would create "42-2025-November.md" instead of "41-2025-October.md"
local function open_or_create_week_file()
  local filename = get_week_filename()
  local cwd = vim.fn.getcwd()
  
  -- Get the year from the week start date
  local monday_time = get_week_start_date()
  local year = os.date("%Y", monday_time)
  
  -- Create the journal/YYYY directory structure
  local journal_dir = cwd .. "/journal/" .. year
  if vim.fn.isdirectory(journal_dir) == 0 then
    vim.fn.mkdir(journal_dir, "p")
  end
  
  -- Full path to the file
  local filepath = journal_dir .. "/" .. filename
  
  -- Open or create the file
  vim.cmd("edit " .. vim.fn.fnameescape(filepath))
end

local function find_or_insert_header(go_to_today)
  -- Open or create the week file if requested
  if go_to_today then
    open_or_create_week_file()
  end
  
  vim.defer_fn(function()
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
  end, 100) -- Defer for 100ms
end

local function insert_header_in_current_buffer()
  find_or_insert_header(false)
end
vim.api.nvim_create_user_command("InsertTodayHeader", insert_header_in_current_buffer, {})

local function insert_header_in_today_buffer()
  find_or_insert_header(true)
end
vim.api.nvim_create_user_command("GoToToday", insert_header_in_today_buffer, {})
