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

-- Function to parse todo items from the current buffer
local function parse_todos_from_buffer()
  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local todos = {}
  
  for line_num, line in ipairs(lines) do
    -- Match todo patterns: - [ ], - [-], - [x] (but we only want incomplete ones)
    local status, content = line:match("^%s*[-*+]%s*%[([^xDo])%]%s*(.+)")
    if status and content then
      -- Only process incomplete todos (not 'x' for completed, 'D' for deleted, or 'o' for obsolete)
      if status ~= 'x' and status ~= 'D' and status ~= 'o' then
        local todo = {
          line_number = line_num,
          content = content,
          status = status,
          priority = nil,
          due_date = nil,
          created_date = nil,
          original_line = line
        }
        
        -- Extract priority (#pri/high, #pri/medium, #pri/low, #pri/urgent)
        local priority_match = content:match("#pri/(%w+)")
        if priority_match then
          todo.priority = priority_match
        end
        
        -- Extract due date (#due/YYYY-MM-DD)
        local due_match = content:match("#due/(%d%d%d%d%-%d%d%-%d%d)")
        if due_match then
          todo.due_date = due_match
        end
        
        -- Extract created date (YYYY-MM-DD at start of line after spaces)
        local created_match = content:match("^(%d%d%d%d%-%d%d%-%d%d)%s")
        if created_match then
          todo.created_date = created_match
        end
        
        table.insert(todos, todo)
      end
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

-- Function to check if a date is within the next week
local function is_within_next_week(date_str)
  if not date_str then return false end
  
  local year, month, day = date_str:match("(%d%d%d%d)%-(%d%d)%-(%d%d)")
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

-- Function to sort todos according to the specified criteria
local function sort_todos(todos)
  table.sort(todos, function(a, b)
    -- 0. In-progress todos come before regular todos
    local a_in_progress = a.status == "-"
    local b_in_progress = b.status == "-"
    
    if a_in_progress and not b_in_progress then return true end
    if b_in_progress and not a_in_progress then return false end
    
    -- 1. Urgent priority first
    if a.priority == "urgent" and b.priority ~= "urgent" then return true end
    if b.priority == "urgent" and a.priority ~= "urgent" then return false end
    
    -- 2. Due dates within next week (by due date)
    local a_due_soon = is_within_next_week(a.due_date)
    local b_due_soon = is_within_next_week(b.due_date)
    
    if a_due_soon and not b_due_soon then return true end
    if b_due_soon and not a_due_soon then return false end
    
    if a_due_soon and b_due_soon then
      return a.due_date < b.due_date
    end
    
    -- 3. High priority
    if a.priority == "high" and b.priority ~= "high" and not b_due_soon then return true end
    if b.priority == "high" and a.priority ~= "high" and not a_due_soon then return false end
    
    -- 4. Other due dates (by date)
    if a.due_date and not b.due_date and not b_due_soon then return true end
    if b.due_date and not a.due_date and not a_due_soon then return false end
    
    if a.due_date and b.due_date then
      return a.due_date < b.due_date
    end
    
    -- 5. Medium priority
    if a.priority == "medium" and b.priority ~= "medium" and not b.due_date and not b_due_soon then return true end
    if b.priority == "medium" and a.priority ~= "medium" and not a.due_date and not a_due_soon then return false end
    
    -- 6. Low priority
    if a.priority == "low" and b.priority ~= "low" and not b.due_date and not b_due_soon then return true end
    if b.priority == "low" and a.priority ~= "low" and not a.due_date and not a_due_soon then return false end
    
    -- 7. Other open todos (by line number for consistency)
    return a.line_number < b.line_number
  end)
end

-- Function to format todo for display
local function format_todo_display(todo)
  local parts = {}
  
  -- Add priority indicator
  if todo.priority then
    local priority_icons = {
      urgent = "🚨",
      high = "🔴",
      medium = "🟡", 
      low = "🟢"
    }
    local icon = priority_icons[todo.priority] or "⚪"
    table.insert(parts, icon)
  end
  
  -- Add due date indicator
  if todo.due_date then
    local due_icon = is_within_next_week(todo.due_date) and "⏰" or "📅"
    table.insert(parts, due_icon .. " " .. todo.due_date)
  end
  
  -- Add the main todo content (clean up the content by removing tags)
  local content = todo.content or "No content"
  -- Remove priority, due date, and created date tags from display
  content = content:gsub("#pri/%w+", "")
  content = content:gsub("#due/%d%d%d%d%-%d%d%-%d%d", "")
  content = content:gsub("^%d%d%d%d%-%d%d%-%d%d%s*%-%s*", "") -- Remove created date at start and following " - "
  content = content:gsub("^%s+", "") -- Remove leading spaces
  content = content:gsub("%s+", " ") -- Collapse multiple spaces to single space
  content = content:gsub("^%s*$", "") -- Remove if empty after cleanup
  
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
    -- Match todo patterns: - [ ], - [-], - [x] (but we only want incomplete ones)
    local status, content = line:match("^%s*[-*+]%s*%[([^xDo])%]%s*(.+)")
    if status and content then
      -- Only process incomplete todos (not 'x' for completed, 'D' for deleted, or 'o' for obsolete)
      if status ~= 'x' and status ~= 'D' and status ~= 'o' then
        local todo = {
          line_number = line_num,
          content = content,
          status = status,
          priority = nil,
          due_date = nil,
          created_date = nil,
          original_line = line,
          file_path = file_path,
          filename = vim.fn.fnamemodify(file_path, ":t")
        }
        
        -- Extract priority (#pri/high, #pri/medium, #pri/low, #pri/urgent)
        local priority_match = content:match("#pri/(%w+)")
        if priority_match then
          todo.priority = priority_match
        end
        
        -- Extract due date (#due/YYYY-MM-DD)
        local due_match = content:match("#due/(%d%d%d%d%-%d%d%-%d%d)")
        if due_match then
          todo.due_date = due_match
        end
        
        -- Extract created date (YYYY-MM-DD at start of line after spaces)
        local created_match = content:match("^(%d%d%d%d%-%d%d%-%d%d)%s")
        if created_match then
          todo.created_date = created_match
        end
        
        table.insert(todos, todo)
      end
    end
  end
  
  return todos
end

-- Function to scan project for todos
local function scan_project_for_todos()
  local cwd = vim.fn.getcwd()
  local all_todos = {}
  
  -- Scan for common note/markdown files
  local file_patterns = {
    "**/*.md",
    "**/*.norg", 
    "**/*.txt",
    "**/notes/**/*",
    "**/projects/**/*",
    "**/meetings/**/*",
    "**/slipbox/**/*"
  }
  
  for _, pattern in ipairs(file_patterns) do
    local success, files = pcall(scan.scan_dir, cwd, {
      search_pattern = pattern,
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
  end
  
  return all_todos
end

-- Function to create the telescope picker for todos
local function todo_whats_next_picker()
  local todos = parse_todos_from_buffer()
  
  if #todos == 0 then
    vim.notify("No incomplete todos found in current buffer", vim.log.levels.INFO)
    return
  end
  
  -- Sort todos according to criteria
  sort_todos(todos)
  
  pickers.new({}, {
    prompt_title = "What's Next - Incomplete Todos",
    finder = finders.new_table({
      results = todos,
      entry_maker = function(entry)
        return {
          value = entry,
          display = format_todo_display(entry),
          ordinal = entry.content,
        }
      end,
    }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        
        -- Jump to the selected todo line
        vim.api.nvim_win_set_cursor(0, {selection.value.line_number, 0})
      end)
      
      -- Add keymap for quick jump without closing picker
      map('i', '<C-j>', function()
        local selection = action_state.get_selected_entry()
        vim.api.nvim_win_set_cursor(0, {selection.value.line_number, 0})
      end)
      
      return true
    end,
  }):find()
end

-- Function to create the telescope picker for project-wide todos
local function todo_project_picker()
  local todos = scan_project_for_todos()
  
  if #todos == 0 then
    vim.notify("No incomplete todos found in project", vim.log.levels.INFO)
    return
  end
  
  -- Sort todos according to criteria
  sort_todos(todos)
  
  pickers.new({}, {
    prompt_title = "Project Todos - Incomplete Todos",
    finder = finders.new_table({
      results = todos,
      entry_maker = function(entry)
        local display = format_todo_display(entry)
        -- Add filename to display
        display = display .. " | " .. entry.filename
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
    previewer = conf.file_previewer({}),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        
        -- Open the file and jump to the selected todo line
        vim.cmd("edit " .. selection.value.file_path)
        vim.api.nvim_win_set_cursor(0, {selection.value.line_number, 0})
      end)
      
      -- Add keymap for quick jump without closing picker
      map('i', '<C-j>', function()
        local selection = action_state.get_selected_entry()
        vim.cmd("edit " .. selection.value.file_path)
        vim.api.nvim_win_set_cursor(0, {selection.value.line_number, 0})
      end)
      
      return true
    end,
  }):find()
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

-- Function to create the telescope picker for in-progress todos in current buffer
local function todo_in_progress_picker()
  local all_todos = parse_todos_from_buffer()
  local todos = filter_in_progress_todos(all_todos)
  
  if #todos == 0 then
    vim.notify("No in-progress todos found in current buffer", vim.log.levels.INFO)
    return
  end
  
  -- Sort todos according to criteria
  sort_todos(todos)
  
  pickers.new({}, {
    prompt_title = "In-Progress Todos - Current Buffer",
    finder = finders.new_table({
      results = todos,
      entry_maker = function(entry)
        return {
          value = entry,
          display = format_todo_display(entry),
          ordinal = entry.content,
        }
      end,
    }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        
        -- Jump to the selected todo line
        vim.api.nvim_win_set_cursor(0, {selection.value.line_number, 0})
      end)
      
      -- Add keymap for quick jump without closing picker
      map('i', '<C-j>', function()
        local selection = action_state.get_selected_entry()
        vim.api.nvim_win_set_cursor(0, {selection.value.line_number, 0})
      end)
      
      return true
    end,
  }):find()
end

-- Function to create the telescope picker for in-progress todos across project
local function todo_project_in_progress_picker()
  local all_todos = scan_project_for_todos()
  local todos = filter_in_progress_todos(all_todos)
  
  if #todos == 0 then
    vim.notify("No in-progress todos found in project", vim.log.levels.INFO)
    return
  end
  
  -- Sort todos according to criteria
  sort_todos(todos)
  
  pickers.new({}, {
    prompt_title = "In-Progress Todos - Project",
    finder = finders.new_table({
      results = todos,
      entry_maker = function(entry)
        local display = format_todo_display(entry)
        -- Add filename to display
        display = display .. " | " .. entry.filename
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
    previewer = conf.file_previewer({}),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        
        -- Open the file and jump to the selected todo line
        vim.cmd("edit " .. selection.value.file_path)
        vim.api.nvim_win_set_cursor(0, {selection.value.line_number, 0})
      end)
      
      -- Add keymap for quick jump without closing picker
      map('i', '<C-j>', function()
        local selection = action_state.get_selected_entry()
        vim.cmd("edit " .. selection.value.file_path)
        vim.api.nvim_win_set_cursor(0, {selection.value.line_number, 0})
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

-- Optional: Add key mappings for quick access
vim.api.nvim_set_keymap('n', '<leader>tn', ':TodoWhatsNext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>tp', ':TodoProject<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ti', ':TodoInProgress<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>tpi', ':TodoProjectInProgress<CR>', { noremap = true, silent = true })
