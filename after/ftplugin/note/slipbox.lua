-- Function to create the actual slipbox file
local function create_slipbox_file(selected_text, start_pos, end_pos)
  -- Clean up the selected text (remove extra whitespace, newlines)
  local clean_text = selected_text:gsub("^%s+", ""):gsub("%s+$", ""):gsub("\n%s+", "\n"):gsub("%s+\n", "\n")
  
  -- Use the first line or first 50 characters as the title
  local title = clean_text:match("^([^\n]+)")
  if not title or title == "" then
    title = clean_text:sub(1, 50)
  end
  
  -- Limit title length and clean it for filename
  if #title > 50 then
    title = title:sub(1, 50)
  end
  
  -- Create a filename-friendly version of the title
  local filename_title = title:gsub("[^%w%s%-_]", ""):gsub("%s+", "-"):gsub("-+", "-"):gsub("^-", ""):gsub("-$", "")
  
  -- Get current date and time
  local date_str = os.date("%d/%m/%Y %H:%M")
  
  -- Create the slipbox content
  local content = {
    "# " .. title .. "\n\n",
    "Date: " .. date_str .. "\n",
    "# Tags\n\n\n"
  }
  
  -- Get current working directory
  local cwd = vim.fn.getcwd()
  local slipbox_dir = cwd .. "/slipbox"
  
  -- Create slipbox directory if it doesn't exist
  if vim.fn.isdirectory(slipbox_dir) == 0 then
    vim.fn.mkdir(slipbox_dir, "p")
  end
  
  -- Create filename with timestamp to ensure uniqueness
  local timestamp = os.date("%Y%m%d%H%M%S")
  local filename = timestamp .. ".md"
  local filepath = slipbox_dir .. "/" .. filename
  
  -- Create the file
  local file = io.open(filepath, "w")
  if file then
    -- Write content to file
    for _, line in ipairs(content) do
      file:write(line)
    end
    file:close()
    
         -- Create the link text with alias (Markdown style)
     local link_text = "[" .. title .. "](slipbox/" .. filename .. ")"
     
     -- Replace the selected text with the link (fixing the boundary)
     if start_pos[1] == end_pos[1] then
       -- Single line replacement
       local line = vim.api.nvim_buf_get_lines(0, start_pos[1] - 1, start_pos[1], false)[1]
       local new_line = line:sub(1, start_pos[2]) .. link_text .. line:sub(end_pos[2] + 2)
       vim.api.nvim_buf_set_lines(0, start_pos[1] - 1, start_pos[1], false, {new_line})
     else
       -- Multi-line replacement
       local lines = vim.api.nvim_buf_get_lines(0, start_pos[1] - 1, end_pos[1], false)
       local first_line = lines[1]
       local last_line = lines[#lines]
       
       local new_lines = {}
       if start_pos[1] == end_pos[1] then
         -- Shouldn't happen, but just in case
         local new_line = first_line:sub(1, start_pos[2]) .. link_text
         table.insert(new_lines, new_line)
       else
         -- Multi-line: replace first line partially, add link, then last line partially
         local new_first = first_line:sub(1, start_pos[2]) .. link_text
         table.insert(new_lines, new_first)
         
         if #lines > 1 then
           local new_last = last_line:sub(end_pos[2] + 1)
           if new_last ~= "" then
             table.insert(new_lines, new_last)
           end
         end
       end
       
       vim.api.nvim_buf_set_lines(0, start_pos[1] - 1, end_pos[1], false, new_lines)
     end
    
    vim.notify("Created slipbox file: " .. filename, vim.log.levels.INFO)
    
    -- Open the new file for editing
    vim.cmd("edit " .. filepath)
  else
    vim.notify("Failed to create slipbox file: " .. filepath, vim.log.levels.ERROR)
  end
end

-- Function to create a slipbox file from selected text
local function create_slipbox_from_selection()
  -- Get the visual selection
  local start_pos = vim.api.nvim_buf_get_mark(0, '<')
  local end_pos = vim.api.nvim_buf_get_mark(0, '>')
  
  -- Check if we have a valid selection
  if not start_pos or not end_pos then
    vim.notify("No text selected", vim.log.levels.WARN)
    return
  end
  
  -- Get the selected text
  local lines = vim.api.nvim_buf_get_lines(0, start_pos[1] - 1, end_pos[1], false)
  if #lines == 0 then
    vim.notify("No text selected", vim.log.levels.WARN)
    return
  end
  
     -- Handle multi-line selection
   if #lines == 1 then
     -- Single line selection
     local line = lines[1]
     local selected_text = line:sub(start_pos[2] + 1, end_pos[2] + 1)
     if selected_text == "" then
       vim.notify("No text selected", vim.log.levels.WARN)
       return
     end
     create_slipbox_file(selected_text, start_pos, end_pos)
   else
    -- Multi-line selection
    local first_line = lines[1]
    local last_line = lines[#lines]
    
         -- Adjust for partial line selections
     if start_pos[1] == end_pos[1] then
       -- Same line, partial selection
       local selected_text = first_line:sub(start_pos[2] + 1, end_pos[2] + 1)
       if selected_text == "" then
         vim.notify("No text selected", vim.log.levels.WARN)
         return
       end
       create_slipbox_file(selected_text, start_pos, end_pos)
     else
      -- Multi-line selection
      local selected_lines = {}
      for i, line in ipairs(lines) do
        if i == 1 then
          -- First line: from start_pos to end
          table.insert(selected_lines, line:sub(start_pos[2] + 1))
                 elseif i == #lines then
           -- Last line: from start to end_pos
           table.insert(selected_lines, line:sub(1, end_pos[2] + 1))
        else
          -- Middle lines: full line
          table.insert(selected_lines, line)
        end
      end
      local selected_text = table.concat(selected_lines, "\n")
      create_slipbox_file(selected_text, start_pos, end_pos)
    end
  end
end

-- Create a user command for creating slipbox files
vim.api.nvim_create_user_command("CreateSlipbox", create_slipbox_from_selection, { range = true })

-- Set up visual mode mapping for Enter key
vim.api.nvim_set_keymap('v', '<CR>', ':CreateSlipbox<CR>', { noremap = true, silent = true })

-- Add to telescope commands
local function list_slipbox_files()
  local cwd = vim.fn.getcwd()
  local slipbox_dir = cwd .. "/slipbox"
  
  -- Check if slipbox directory exists
  if vim.fn.isdirectory(slipbox_dir) == 0 then
    vim.notify("Slipbox directory does not exist: " .. slipbox_dir, vim.log.levels.WARN)
    return
  end
  
  -- Scan for files in the slipbox directory
  local scan = require('plenary.scandir')
  local files = scan.scan_dir(slipbox_dir, {
    depth = 2,
    add_dirs = false,
  })
  
  -- Format the results for display
  local results = {}
  for _, file_path in ipairs(files) do
    local filename = vim.fn.fnamemodify(file_path, ":t")
    local first_heading = ""
    
    -- Read the file and extract the first heading
    local file = io.open(file_path, "r")
    if file then
      for line in file:lines() do
        if line:match("^#%s+") then
          first_heading = line:gsub("^#%s+", "")
          break
        end
      end
      file:close()
    end
    
    -- Use the first heading if found, otherwise use the filename
    local display_name = first_heading ~= "" and first_heading or filename
    
    table.insert(results, {
      filename = filename,
      path = file_path,
      heading = display_name,
    })
  end
  
  -- Create the picker
  local pickers = require('telescope.pickers')
  local finders = require('telescope.finders')
  local conf = require('telescope.config').values
  local actions = require('telescope.actions')
  local action_state = require('telescope.actions.state')
  
  pickers.new({}, {
    prompt_title = "Slipbox Files",
    finder = finders.new_table({
      results = results,
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry.heading .. " (" .. entry.filename .. ")",
          ordinal = entry.filename,
          path = entry.path,
        }
      end,
    }),
    sorter = conf.generic_sorter({}),
    previewer = conf.file_previewer({}),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        
        -- Open the selected file
        vim.cmd("edit " .. selection.path)
      end)
      return true
    end,
  }):find()
end

-- Create a user command to list slipbox files
vim.api.nvim_create_user_command("ListSlipbox", list_slipbox_files, {})

-- Register with telescope (only if telescope is available)
local ok, telescope = pcall(require, 'telescope')
if ok then
  telescope.register_extension({
    exports = {
      slipbox_files = list_slipbox_files,
    }
  })
end 