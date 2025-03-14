local telescope = require('telescope')
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local conf = require('telescope.config').values
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')

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
    { name = "MarkTodoTagComplete", description = "Mark a todo tag as complete" }
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
vim.api.nvim_set_keymap('n', '<leader>nc', ':NoteCommands<CR>', { noremap = true, silent = true })

-- Register the picker with Telescope (so it can be accessed via :Telescope note_commands)
telescope.register_extension({
  exports = {
    note_commands = note_commands_picker
  }
})

