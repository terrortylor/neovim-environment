local ok, telescope = pcall(require, 'telescope')
if not ok then
  return
end

local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local conf = require('telescope.config').values
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local scan = require('plenary.scandir')

-- Constants
local TODO_PATTERNS = {
  regex = "^%s*[-*+]%s*%[([^xDo])%]%s*(.+)",
  excluded_statuses = { "x", "D", "o" }
}

local PRIORITY_ICONS = {
  overdue = "💀",
  urgent = "🚨",
  high = "🔴",
  medium = "🟡", 
  low = "🟢"
}

local DUE_DATE_ICONS = {
  soon = "⏰",
  other = "📅"
}

local STATUS_ICONS = {
  in_progress = "🔄"
}

local MATCH_PATTERNS = {
  priority = "#pri/(%w+)",
  due_date = "#due/(%d%d%d%d%-%d?%d%-%d?%d)",
  created_date = "^(%d%d%d%d%-%d?%d%-%d?%d)%s",
  date_components = "(%d%d%d%d)%-(%d?%d)%-(%d?%d)"
}

local CONTENT_CLEANUP_PATTERNS = {
  priority = "#pri/%w+",
  due_date = "#due/%d%d%d%d%-%d?%d%-%d?%d",
  created_date = "^%d%d%d%d%-%d?%d%-%d?%d%s*%-%s*",
  leading_spaces = "^%s+",
  multiple_spaces = "%s+",
  empty_after_cleanup = "^%s*$"
}

-- Common function to parse a single todo line
local function parse_todo_line(line, line_num, file_path)
  local status, content = line:match(TODO_PATTERNS.regex)
  if not status or not content then
    return nil
  end
  
  -- Check if status is excluded
  for _, excluded in ipairs(TODO_PATTERNS.excluded_statuses) do
    if status == excluded then
      return nil
    end
  end
  
  local todo = {
    line_number = line_num,
    content = content,
    status = status,
    priority = nil,
    due_date = nil,
    created_date = nil,
    original_line = line
  }
  
  if file_path then
    todo.file_path = file_path
    todo.filename = vim.fn.fnamemodify(file_path, ":t")
  end
  
  -- Extract priority (#pri/high, #pri/medium, #pri/low, #pri/urgent)
  local priority_match = content:match(MATCH_PATTERNS.priority)
  if priority_match then
    todo.priority = priority_match
  end
  
  -- Extract due date (#due/YYYY-MM-DD)
  local due_match = content:match(MATCH_PATTERNS.due_date)
  if due_match then
    todo.due_date = due_match
  end
  
  -- Extract created date (YYYY-MM-DD at start of line after spaces)
  local created_match = content:match(MATCH_PATTERNS.created_date)
  if created_match then
    todo.created_date = created_match
  end
  
  return todo
end

-- Function to parse todo items from the current buffer
local function parse_todos_from_buffer()
  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local todos = {}
  
  for line_num, line in ipairs(lines) do
    local todo = parse_todo_line(line, line_num)
    if todo then
      table.insert(todos, todo)
    end
  end
  
  return todos
end

-- Function to get priority weight for sorting
local function get_priority_weight(priority)
  local weights = {
    urgent = 1,
    high = 3,
    medium = 4,
    low = 5
  }
  return weights[priority] or 6 -- Default weight for no priority
end

-- Function to check if a date is overdue
local function is_overdue(date_str)
  if not date_str then return false end
  
  local year, month, day = date_str:match(MATCH_PATTERNS.date_components)
  if not year or not month or not day then return false end
  
  local todo_date = os.time({
    year = tonumber(year),
    month = tonumber(month),
    day = tonumber(day)
  })
  
  local now = os.time()
  local today = os.time({
    year = tonumber(os.date("%Y")),
    month = tonumber(os.date("%m")),
    day = tonumber(os.date("%d"))
  })
  
  return todo_date < today
end

-- Function to check if a date is within the next week
local function is_within_next_week(date_str)
  if not date_str then return false end
  
  local year, month, day = date_str:match(MATCH_PATTERNS.date_components)
  if not year or not month or not day then return false end
  
  local todo_date = os.time({
    year = tonumber(year),
    month = tonumber(month),
    day = tonumber(day)
  })
  
  local now = os.time()
  local week_from_now = now + (7 * 24 * 60 * 60) -- 7 days in seconds
  
  return todo_date >= now and todo_date <= week_from_now
end

-- Individual comparison functions for each priority rule
local function compare_in_progress(a, b)
  local a_in_progress = a.status == "-"
  local b_in_progress = b.status == "-"
  
  if a_in_progress and not b_in_progress then return true end
  if b_in_progress and not a_in_progress then return false end
  return nil -- No difference, continue to next rule
end

local function compare_overdue(a, b)
  local a_overdue = is_overdue(a.due_date)
  local b_overdue = is_overdue(b.due_date)
  
  if a_overdue and not b_overdue then return true end
  if b_overdue and not a_overdue then return false end
  
  if a_overdue and b_overdue then
    return a.due_date < b.due_date -- Sort overdue by date (oldest first)
  end
  
  return nil -- No difference, continue to next rule
end

local function compare_urgent_priority(a, b)
  local a_urgent = a.priority == "urgent"
  local b_urgent = b.priority == "urgent"
  
  if a_urgent and not b_urgent then return true end
  if b_urgent and not a_urgent then return false end
  return nil -- No difference, continue to next rule
end

local function compare_due_soon(a, b)
  local a_due_soon = is_within_next_week(a.due_date)
  local b_due_soon = is_within_next_week(b.due_date)
  
  if a_due_soon and not b_due_soon then return true end
  if b_due_soon and not a_due_soon then return false end
  
  if a_due_soon and b_due_soon then
    return a.due_date < b.due_date
  end
  
  return nil -- No difference, continue to next rule
end

local function compare_high_priority(a, b)
  local a_high = a.priority == "high"
  local b_high = b.priority == "high"
  
  if a_high and not b_high then return true end
  if b_high and not a_high then return false end
  return nil -- No difference, continue to next rule
end

local function compare_other_due_dates(a, b)
  local a_has_due = a.due_date and not is_within_next_week(a.due_date) and not is_overdue(a.due_date)
  local b_has_due = b.due_date and not is_within_next_week(b.due_date) and not is_overdue(b.due_date)
  
  if a_has_due and not b_has_due then return true end
  if b_has_due and not a_has_due then return false end
  
  if a_has_due and b_has_due then
    return a.due_date < b.due_date
  end
  
  return nil -- No difference, continue to next rule
end

local function compare_medium_priority(a, b)
  local a_medium = a.priority == "medium"
  local b_medium = b.priority == "medium"
  
  if a_medium and not b_medium then return true end
  if b_medium and not a_medium then return false end
  return nil -- No difference, continue to next rule
end

local function compare_low_priority(a, b)
  local a_low = a.priority == "low"
  local b_low = b.priority == "low"
  
  if a_low and not b_low then return true end
  if b_low and not a_low then return false end
  return nil -- No difference, continue to next rule
end

local function compare_line_number(a, b)
  return a.line_number < b.line_number
end

-- Function to sort todos according to the specified criteria
local function sort_todos(todos)
  -- Define the order of comparison rules (highest to lowest priority)
  local comparison_rules = {
    compare_in_progress,      -- 1. In-progress todos come before regular todos
    compare_overdue,          -- 2. Overdue todos first (highest priority)
    compare_urgent_priority,  -- 3. Urgent priority
    compare_due_soon,         -- 4. Due dates within next week
    compare_high_priority,    -- 5. High priority
    compare_other_due_dates,  -- 6. Other due dates
    compare_medium_priority,  -- 7. Medium priority
    compare_low_priority,     -- 8. Low priority
    compare_line_number       -- 9. Line number (fallback)
  }
  
  table.sort(todos, function(a, b)
    -- Try each comparison rule in order
    for _, compare_func in ipairs(comparison_rules) do
      local result = compare_func(a, b)
      if result ~= nil then
        return result
      end
    end
    
    -- This should never be reached due to the line_number fallback
    return false
  end)
end

-- Function to format todo for display
local function format_todo_display(todo)
  local parts = {}
  
  -- Add status indicator (in-progress)
  if todo.status == "-" then
    table.insert(parts, STATUS_ICONS.in_progress)
  end
  
  -- Add priority indicator (overdue takes precedence over manual priority)
  if is_overdue(todo.due_date) then
    table.insert(parts, PRIORITY_ICONS.overdue)
  elseif todo.priority then
    local icon = PRIORITY_ICONS[todo.priority] or "⚪"
    table.insert(parts, icon)
  end
  
  -- Add due date indicator
  if todo.due_date then
    local due_icon = is_overdue(todo.due_date) and "💀" or (is_within_next_week(todo.due_date) and DUE_DATE_ICONS.soon or DUE_DATE_ICONS.other)
    table.insert(parts, due_icon .. " " .. todo.due_date)
  end
  
  -- Add the main todo content (clean up the content by removing tags)
  local content = todo.content or "No content"
  -- Remove priority, due date, and created date tags from display
  content = content:gsub(CONTENT_CLEANUP_PATTERNS.priority, "")
  content = content:gsub(CONTENT_CLEANUP_PATTERNS.due_date, "")
  content = content:gsub(CONTENT_CLEANUP_PATTERNS.created_date, "") -- Remove created date at start and following " - "
  content = content:gsub(CONTENT_CLEANUP_PATTERNS.leading_spaces, "") -- Remove leading spaces
  content = content:gsub(CONTENT_CLEANUP_PATTERNS.multiple_spaces, " ") -- Collapse multiple spaces to single space
  content = content:gsub(CONTENT_CLEANUP_PATTERNS.empty_after_cleanup, "") -- Remove if empty after cleanup
  
  if content and content ~= "" then
    table.insert(parts, content)
  end
  
  -- Add created date if present
  if todo.created_date then
    table.insert(parts, "(created: " .. todo.created_date .. ")")
  end
  
  return table.concat(parts, " | ")
end

-- Function to parse todos from a specific file
local function parse_todos_from_file(file_path)
  local todos = {}
  local file = io.open(file_path, "r")
  if not file then
    return todos
  end
  
  local lines = {}
  for line in file:lines() do
    table.insert(lines, line)
  end
  file:close()
  
  for line_num, line in ipairs(lines) do
    local todo = parse_todo_line(line, line_num, file_path)
    if todo then
      table.insert(todos, todo)
    end
  end
  
  return todos
end

-- Function to scan project for todos
local function scan_project_for_todos()
  local cwd = vim.fn.getcwd()
  local all_todos = {}
  
  -- Scan for .md files in the current working directory and subdirectories
  local success, files = pcall(scan.scan_dir, cwd, {
    search_pattern = "**/*.md",
    depth = 10,
    add_dirs = false,
  })
  
  if success and files then
    for _, file_path in ipairs(files) do
      -- Ensure file_path is a string
      if type(file_path) == "string" then
        local file_todos = parse_todos_from_file(file_path)
        for _, todo in ipairs(file_todos) do
          -- Ensure file_path is properly set
          todo.file_path = file_path
          table.insert(all_todos, todo)
        end
      end
    end
  end
  
  return all_todos
end

-- Function to filter todos to only in-progress ones
local function filter_in_progress_todos(todos)
  local in_progress_todos = {}
  for _, todo in ipairs(todos) do
    if todo.status == "-" then
      table.insert(in_progress_todos, todo)
    end
  end
  return in_progress_todos
end

-- Common telescope picker creation function
local function create_todo_picker(todos, title, show_filename)
  if #todos == 0 then
    vim.notify("No todos found", vim.log.levels.INFO)
    return
  end
  
  -- Sort todos according to criteria
  sort_todos(todos)
  
  pickers.new({}, {
    prompt_title = title,
    finder = finders.new_table({
      results = todos,
      entry_maker = function(entry)
        local display = format_todo_display(entry)
        if show_filename and entry.filename then
          display = display .. " | " .. entry.filename
        end
        return {
          value = entry,
          display = display,
          ordinal = entry.content,
          path = entry.file_path,
          filename = entry.filename,
        }
      end,
    }),
    sorter = conf.generic_sorter({}),
    previewer = show_filename and conf.file_previewer({}) or nil,
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        
        if show_filename and selection.value.file_path then
          -- Open the file and jump to the selected todo line
          vim.cmd("edit " .. selection.value.file_path)
        end
        vim.api.nvim_win_set_cursor(0, {selection.value.line_number, 0})
      end)
      
      -- Add keymap for quick jump without closing picker
      map('i', '<C-j>', function()
        local selection = action_state.get_selected_entry()
        if show_filename and selection.value.file_path then
          vim.cmd("edit " .. selection.value.file_path)
        end
        vim.api.nvim_win_set_cursor(0, {selection.value.line_number, 0})
      end)
      
      return true
    end,
  }):find()
end

-- Function to create the telescope picker for todos
local function todo_whats_next_picker()
  local todos = parse_todos_from_buffer()
  create_todo_picker(todos, "What's Next - Incomplete Todos", false)
end

-- Function to create the telescope picker for project-wide todos
local function todo_project_picker()
  local todos = scan_project_for_todos()
  create_todo_picker(todos, "Project Todos - Incomplete Todos", true)
end

-- Function to create the telescope picker for in-progress todos in current buffer
local function todo_in_progress_picker()
  local all_todos = parse_todos_from_buffer()
  local todos = filter_in_progress_todos(all_todos)
  create_todo_picker(todos, "In-Progress Todos - Current Buffer", false)
end

-- Function to create the telescope picker for in-progress todos across project
local function todo_project_in_progress_picker()
  local all_todos = scan_project_for_todos()
  local todos = filter_in_progress_todos(all_todos)
  create_todo_picker(todos, "In-Progress Todos - Project", true)
end

-- Function to get files with todos and their counts
local function get_files_with_todos()
  local cwd = vim.fn.getcwd()
  local file_counts = {}
  
  -- Scan for .md files in the current working directory and subdirectories
  local success, files = pcall(scan.scan_dir, cwd, {
    search_pattern = "**/*.md",
    depth = 10,
    add_dirs = false,
  })
  
  if success and files then
    for _, file_path in ipairs(files) do
      if type(file_path) == "string" then
        local file_todos = parse_todos_from_file(file_path)
        if #file_todos > 0 then
          local filename = vim.fn.fnamemodify(file_path, ":t")
          local relative_path = vim.fn.fnamemodify(file_path, ":.")
          file_counts[file_path] = {
            filename = filename,
            relative_path = relative_path,
            todo_count = #file_todos,
            in_progress_count = 0
          }
          
          -- Count in-progress todos
          for _, todo in ipairs(file_todos) do
            if todo.status == "-" then
              file_counts[file_path].in_progress_count = file_counts[file_path].in_progress_count + 1
            end
          end
        end
      end
    end
  end
  
  return file_counts
end

-- Function to create the telescope picker for files with in-progress todos
local function todo_in_progress_files_picker()
  local file_counts = get_files_with_todos()
  local files_with_in_progress = {}
  
  for file_path, info in pairs(file_counts) do
    if info.in_progress_count > 0 then
      table.insert(files_with_in_progress, {
        file_path = file_path,
        filename = info.filename,
        relative_path = info.relative_path,
        in_progress_count = info.in_progress_count,
        total_count = info.todo_count
      })
    end
  end
  
  if #files_with_in_progress == 0 then
    vim.notify("No files with in-progress todos found", vim.log.levels.INFO)
    return
  end
  
  -- Sort by in-progress count (descending)
  table.sort(files_with_in_progress, function(a, b)
    return a.in_progress_count > b.in_progress_count
  end)
  
  pickers.new({}, {
    prompt_title = "Files with In-Progress Todos",
    finder = finders.new_table({
      results = files_with_in_progress,
      entry_maker = function(entry)
        local display = entry.filename .. " (" .. entry.in_progress_count .. " in-progress, " .. entry.total_count .. " total)"
        return {
          value = entry,
          display = display,
          ordinal = entry.filename,
          path = entry.file_path,
          filename = entry.filename,
        }
      end,
    }),
    sorter = conf.generic_sorter({}),
    previewer = conf.file_previewer({}),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        vim.cmd("edit " .. selection.value.file_path)
      end)
      
      map('i', '<C-j>', function()
        local selection = action_state.get_selected_entry()
        vim.cmd("edit " .. selection.value.file_path)
      end)
      
      return true
    end,
  }):find()
end

-- Function to create the telescope picker for all files with todos
local function todo_project_files_picker()
  local file_counts = get_files_with_todos()
  local files_with_todos = {}
  
  for file_path, info in pairs(file_counts) do
    table.insert(files_with_todos, {
      file_path = file_path,
      filename = info.filename,
      relative_path = info.relative_path,
      in_progress_count = info.in_progress_count,
      total_count = info.todo_count
    })
  end
  
  if #files_with_todos == 0 then
    vim.notify("No files with todos found", vim.log.levels.INFO)
    return
  end
  
  -- Sort by total todo count (descending)
  table.sort(files_with_todos, function(a, b)
    return a.total_count > b.total_count
  end)
  
  pickers.new({}, {
    prompt_title = "Files with Todos",
    finder = finders.new_table({
      results = files_with_todos,
      entry_maker = function(entry)
        local display = entry.filename .. " (" .. entry.total_count .. " todos"
        if entry.in_progress_count > 0 then
          display = display .. ", " .. entry.in_progress_count .. " in-progress"
        end
        display = display .. ")"
        return {
          value = entry,
          display = display,
          ordinal = entry.filename,
          path = entry.file_path,
          filename = entry.filename,
        }
      end,
    }),
    sorter = conf.generic_sorter({}),
    previewer = conf.file_previewer({}),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        vim.cmd("edit " .. selection.value.file_path)
      end)
      
      map('i', '<C-j>', function()
        local selection = action_state.get_selected_entry()
        vim.cmd("edit " .. selection.value.file_path)
      end)
      
      return true
    end,
  }):find()
end

-- Create user commands
vim.api.nvim_create_user_command("TodoWhatsNext", todo_whats_next_picker, {
  desc = "List incomplete todos in current buffer ordered by priority and due date"
})

vim.api.nvim_create_user_command("TodoProject", todo_project_picker, {
  desc = "List all incomplete todos in project ordered by priority and due date"
})

vim.api.nvim_create_user_command("TodoInProgress", todo_in_progress_picker, {
  desc = "List in-progress todos in current buffer ordered by priority and due date"
})

vim.api.nvim_create_user_command("TodoProjectInProgress", todo_project_in_progress_picker, {
  desc = "List all in-progress todos in project ordered by priority and due date"
})

vim.api.nvim_create_user_command("TodoInProgressFiles", todo_in_progress_files_picker, {
  desc = "List files containing in-progress todos"
})

vim.api.nvim_create_user_command("TodoProjectFiles", todo_project_files_picker, {
  desc = "List all files containing todos"
})

-- Optional: Add key mappings for quick access
vim.api.nvim_set_keymap('n', '<leader>tn', ':TodoWhatsNext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>tp', ':TodoProject<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ti', ':TodoInProgress<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>tpi', ':TodoProjectInProgress<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>tif', ':TodoInProgressFiles<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>tpf', ':TodoProjectFiles<CR>', { noremap = true, silent = true })
