-- Function to create a new note file with customizable parameters
local function create_note_file(filetype, folder, contentsfunc, includeYearSubDir, insert_link)
  -- Default values if not provided
  filetype = filetype or "note"
  folder = folder or "notes"
  contentsfunc = contentsfunc or function(title) 
    return {
      "# " .. title .. "\n\n",
      "Date: " .. os.date("%d-%m-%Y") .. "\n\n",
      "# Tags\n\n\n"
    }
  end
  insert_link = insert_link or false
  
  -- Use vim.ui.input to get the note title
  vim.ui.input({
    prompt = filetype:gsub("^%l", string.upper) .. " title: ", -- Capitalize first letter
  }, function(input)
    -- Check if input was provided (not nil or empty)
    if not input or input == "" then
      vim.notify("No " .. filetype .. " title provided, operation cancelled", vim.log.levels.INFO)
      return
    end
    
    -- Get current date in YYYY-MM-DD format
    local date_str = os.date("%Y-%m-%d")
    
    -- Replace spaces with hyphens in the input
    local formatted_title = input:gsub(" ", "-")
    
    -- Create the filename with date prefix
    local filename = date_str .. "-" .. formatted_title .. ".md"
    
    -- Get the current working directory
    local cwd = vim.fn.getcwd()
    
    -- Create the directory if it doesn't exist
    local year = os.date("%Y")
    local target_dir = cwd .. "/" .. folder
    if include_year_sub_dir then
      target_dir = target_dir .. "/" .. year
    end
    if vim.fn.isdirectory(target_dir) == 0 then
      vim.fn.mkdir(target_dir, "p")
    end
    
    -- Full path to the new file
    local filepath = target_dir .. "/" .. filename
    
    -- Check if file already exists
    if vim.fn.filereadable(filepath) == 1 then
      vim.notify("File already exists: " .. filepath, vim.log.levels.WARN)
    else
      -- Create an empty file
      local file = io.open(filepath, "w")
      if file then
        -- Get content from the contentsfunc
        local contents = contentsfunc(input)
        
        -- Write all content lines to the file
        for _, line in ipairs(contents) do
          file:write(line)
        end
        
        file:close()
        vim.notify("Created " .. filetype .. " note: " .. filename, vim.log.levels.INFO)
      else
        vim.notify("Failed to create file: " .. filepath, vim.log.levels.ERROR)
        return
      end
    end
    
    -- Insert link in current buffer at cursor position if requested
    if insert_link then
      local link_text = "[[" .. filename:gsub("%.md$", "") .. "]]"
      local cursor_pos = vim.api.nvim_win_get_cursor(0)
      local line = vim.api.nvim_get_current_line()
      local col = cursor_pos[2]
      
      -- Insert the link at cursor position
      local new_line = line:sub(1, col) .. link_text .. line:sub(col + 1)
      vim.api.nvim_set_current_line(new_line)
      
      -- Move cursor after the inserted link
      vim.api.nvim_win_set_cursor(0, {cursor_pos[1] + 1, col + #link_text})
    end
    
    -- Open the file for editing
    vim.cmd("edit " .. filepath)
  end)
end



-- Define meeting note content function
local function meeting_note_contents(title)
  return {
    "# Meeting: " .. title .. "\n\n",
    "Date: " .. os.date("%d-%m-%Y") .. "\n\n",
    "",
    "# Attendees\n\n\n",
    "",
    "# Agenda\n\n\n",
    "",
    "# Notes\n\n\n",
    "",
    "# Action Items\n\n\n",
    "",
    "# Tags\n\n\n"
  }
end

-- Function to create a meeting note with link (default behavior)
local function create_meeting_note()
  create_note_file("Meeting", "meetings", meeting_note_contents, true, true)
end

-- Function to create a meeting note without link
local function create_meeting_note_without_link()
  create_note_file("Meeting", "meetings", meeting_note_contents, true, false)
end

-- Define project note content function
local function project_contents(title)
  return {
    "# Project: " .. title .. "\n\n",
    "",
    "# Action Items\n\n\n",
    "",
    "# Tags\n\n\n"
  }
end

-- Function to create a project note with link (default behavior)
local function create_new_project()
  create_note_file("Project", "projects", project_contents, false, true)
end

-- Function to create a project note without link
local function create_new_project_without_link()
  create_note_file("Project", "projects", project_contents, false, false)
end

vim.api.nvim_create_user_command("NewMeeting", create_meeting_note, {})
vim.api.nvim_create_user_command("NewMeetingWithoutLink", create_meeting_note_without_link, {})
vim.api.nvim_create_user_command("NewProject", create_new_project, {})
vim.api.nvim_create_user_command("NewProjectWithoutLink", create_new_project_without_link, {})
