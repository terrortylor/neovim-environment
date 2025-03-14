-- Function to create a new note file with customizable parameters
local function create_note_file(filetype, folder, contentsfunc, includeYearSubDir)
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

-- Function to create a meeting note (wrapper for backward compatibility)
local function create_meeting_note()
  create_note_file("Meeting", "meetings", meeting_note_contents, true)
end

-- Define meeting note content function
local function project_contents(title)
  return {
    "# Project: " .. title .. "\n\n",
    "",
    "# Tags\n\n\n"
  }
end


vim.api.nvim_create_user_command("NewMeeting", create_meeting_note, {})

local function create_new_project()
  create_note_file("Project", "projects", project_contents, false)
end

vim.api.nvim_create_user_command("NewProject", create_new_project, {})
