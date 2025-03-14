-- Function to convert a regular markdown list item to a todo list item
local function convert_to_todo_item()
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local current_line_num = cursor_pos[1] - 1  -- Convert to 0-indexed
  
  -- Get the current line
  local current_line = vim.api.nvim_buf_get_lines(bufnr, current_line_num, current_line_num + 1, false)[1]
  
  -- Check if the line is a list item without a todo checkbox
  -- Match patterns like "- item" or "* item" or "+ item" but not "- [ ] item"
  if current_line:match("^%s*[-*+]%s+[^[]") then
    -- Add the todo checkbox after the list marker
    local new_line = current_line:gsub("^(%s*[-*+])(%s+)(.+)", "%1%2[ ] %3")
    
    -- Update the line in the buffer
    vim.api.nvim_buf_set_lines(bufnr, current_line_num, current_line_num + 1, false, {new_line})
    
    -- Keep cursor at the same position
    vim.api.nvim_win_set_cursor(0, cursor_pos)
  end
end

-- Create a user command to call the function
vim.api.nvim_create_user_command("ConvertToTodoItem", convert_to_todo_item, {})

-- Optional: Add a key mapping for quick access
-- vim.api.nvim_set_keymap('n', '<leader>ct', ':ConvertToTodoItem<CR>', { noremap = true, silent = true })
