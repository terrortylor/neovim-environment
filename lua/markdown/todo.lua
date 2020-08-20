-- Adds some support functionality for handling TODO checkboxes to markdown
-- It's dependant on having the formatoptions 'o' set to automatically handle
-- inserting a */- on a new line after o/O in normal mode.


-- Things TODO?
-- explore formatlistpat so wrapping works with
-- add some way on handling functionality without o formatoption
local api = vim.api

local M = {}

-- Returns true/false depending on if the
-- line is a listed TODO checkbox item
function is_line_todo_item(line)
  local marker = line:match('%s*[*-]%s%[[%sox]%]')
  if marker then
    return true
  else
    return false
  end
end

-- luaeval("require('markdown.todo').insert_empty_todo_box(true)")
--
-- To be used after build in o/O in normal mode
-- Checks if in a todo todo and adds a new empty todo item notation
-- after */- todo notation
function M.insert_empty_todo_box(down)
  local previous_line_nr, _ = unpack(vim.api.nvim_win_get_cursor(0))

  if down then
    -- get line above
    previous_line_nr = previous_line_nr - 1
  else
    -- get line below
    previous_line_nr = previous_line_nr + 1
  end

  -- Capture line o/O was triggered from
  local previous_line = vim.api.nvim_buf_get_lines(0, previous_line_nr - 1, previous_line_nr, false)[1]

  -- if line is not nil and line was a TODO checked item
  -- return new empty check box
  if previous_line and is_line_todo_item(previous_line) then
    return '[ ] '
  end
  return ''
end
-- export locals for test
if _TEST then
  M._is_line_todo_item = is_line_todo_item
end

return M
