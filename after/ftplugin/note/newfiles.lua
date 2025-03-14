-- Function to create a new meeting note file
local function create_meeting_note()
  -- Use vim.ui.input to get the meeting title
  vim.ui.input({
    prompt = "Meeting title: ",
  }, function(input)
    -- Check if input was provided (not nil or empty)
    if not input or input == "" then
      vim.notify("No meeting title provided, operation cancelled", vim.log.levels.INFO)
      return
    end
    
    -- Get current date in YYYYMMDD format
    local date_str = os.date("%Y-%m-%d")
    
    -- Replace spaces with hyphens in the input
    local formatted_title = input:gsub(" ", "-")
    
    -- Create the filename with date prefix
    local filename = date_str .. "-" .. formatted_title .. ".md"
    
    -- Get the current working directory
    local cwd = vim.fn.getcwd()
    
    -- Create the meetings directory if it doesn't exist
    local year = os.date("%Y")
    local meetings_dir = cwd .. "/" .. year .."/meetings"
    if vim.fn.isdirectory(meetings_dir) == 0 then
      vim.fn.mkdir(meetings_dir, "p")
    end
    
    -- Full path to the new file
    local filepath = meetings_dir .. "/" .. filename
    
    -- Check if file already exists
    if vim.fn.filereadable(filepath) == 1 then
      vim.notify("File already exists: " .. filepath, vim.log.levels.WARN)
    else
      -- Create an empty file
      local file = io.open(filepath, "w")
      if file then
        -- Add a title to the file
        file:write("# Meeting: " .. input .. "\n\n")
        file:write("Date: " .. os.date("%d-%m-%Y") .. "\n\n")
        file:write("# Attendees\n\n\n")
        file:write("# Agenda\n\n\n")
        file:write("# Notes\n\n\n")
        file:write("# Action Items\n\n\n")
        file:write("# Tags\n\n\n")
        file:close()
        vim.notify("Created meeting note: " .. filename, vim.log.levels.INFO)
      else
        vim.notify("Failed to create file: " .. filepath, vim.log.levels.ERROR)
        return
      end
    end
    
    -- Open the file for editing
    vim.cmd("edit " .. filepath)
  end)
end

-- Create a user command to call the function
vim.api.nvim_create_user_command("NewMeeting", create_meeting_note, {})

