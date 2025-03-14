local function mark_todo_tag_complete()
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local current_line_num = cursor_pos[1] - 1  -- Convert to 0-indexed
  
  -- Get the current line
  local current_line = vim.api.nvim_buf_get_lines(bufnr, current_line_num, current_line_num + 1, false)[1]
  
  -- Check if the line starts with "#Retro/Raise/todo"
  if current_line:match("^#%w+/Raise/todo") then
    -- Replace "#Retro/Raise/todo" with "#Retro/Raise"
    local new_Line = current_line:gsub("^#%w+/Raise/todo", function(match)
      return match:gsub("/todo$", "")
    end)
    
    -- Update the line in the buffer
    vim.api.nvim_buf_set_lines(bufnr, current_line_num, current_line_num + 1, false, {new_line})
    
    -- Keep cursor at the same position
    vim.api.nvim_win_set_cursor(0, cursor_pos)
  end
end

vim.api.nvim_create_user_command("MarkTodoTagComplete", mark_todo_tag_complete, {})
