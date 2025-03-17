local telescope = require('telescope')
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local conf = require('telescope.config').values
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local scan = require('plenary.scandir')

-- Function to collect all user commands from note filetype plugins
local function get_note_commands()
  local commands = {}
  
  -- List of commands we've created in our note plugins
  local note_command_list = {
    { name = "NewMeeting", description = "Create a new meeting note file" },
    { name = "NewProject", description = "Creates a new project file"},
    { name = "AddAttendee", description = "Add an attendee to the current note" },
    { name = "AddTag", description = "Add a tag to the current note" },
    { name = "TodayGoToOrInsert", description = "Go to or insert today's date header" },
    { name = "ConvertToTodoItem", description = "Convert a list item to a todo item" },
    { name = "MarkTodoTagComplete", description = "Mark a todo tag as complete" },
    { name = "ListProjects", description = "List and open project files" }
  }
  
  for _, cmd in ipairs(note_command_list) do
    table.insert(commands, cmd)
  end
  
  return commands
end

-- Function to open the Telescope picker for note commands
local function note_commands_picker()
  local commands = get_note_commands()
  
  pickers.new({}, {
    prompt_title = "Note Commands",
    finder = finders.new_table({
      results = commands,
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry.name .. " - " .. entry.description,
          ordinal = entry.name,
        }
      end,
    }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        
        -- Execute the selected command
        vim.cmd(selection.value.name)
      end)
      return true
    end,
  }):find()
end

-- Create a user command to open the note commands picker
vim.api.nvim_create_user_command("NoteCommands", note_commands_picker, {})

-- Create a keymap for quick access (optional)
vim.api.nvim_set_keymap('n', '<leader>rr', ':NoteCommands<CR>', { noremap = true, silent = true })

-- Function to list and open project files
local function list_project_files()
  local cwd = vim.fn.getcwd()
  local projects_dir = cwd .. "/projects"
  
  -- Check if projects directory exists
  if vim.fn.isdirectory(projects_dir) == 0 then
    vim.notify("Projects directory does not exist: " .. projects_dir, vim.log.levels.WARN)
    return
  end
  
  -- Scan for files in the projects directory
  local files = scan.scan_dir(projects_dir, {
    depth = 1,  -- Only scan the immediate directory
    add_dirs = false,  -- Don't include directories in results
  })
  
  -- Format the results for display
  local results = {}
  for _, file_path in ipairs(files) do
    local filename = vim.fn.fnamemodify(file_path, ":t")
    table.insert(results, {
      filename = filename,
      path = file_path,
    })
  end
  
  -- Create the picker
  pickers.new({}, {
    prompt_title = "Project Files",
    finder = finders.new_table({
      results = results,
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry.filename,
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

-- Create a user command to list project files
vim.api.nvim_create_user_command("ListProjects", list_project_files, {})

-- Create a keymap for quick access to project files
vim.api.nvim_set_keymap('n', '<leader>rp', ':ListProjects<CR>', { noremap = true, silent = true })

-- Register the picker with Telescope (so it can be accessed via :Telescope note_commands)
telescope.register_extension({
  exports = {
    note_commands = note_commands_picker,
    project_files = list_project_files
  }
})

