-- Adds some support functionality for handling TODO checkboxes to markdown
-- It's dependant on having the formatoptions 'o' set to automatically handle
-- inserting a */- on a new line after o/O in normal mode.


-- Things TODO?
-- explore formatlistpat so wrapping works with
-- add some way on handling functionality without o formatoption
-- move plug mapping to here
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

function M.set_todo_state(state)
    local line = api.nvim_get_current_line()
    if is_line_todo_item(line) then
      if state:match("[%sxo]") then
        line = line:gsub("%[[%sox]%]", "[" .. state .. "]", 1)
        api.nvim_set_current_line(line)
      end
    end
end

-- Called when pressing <CR> in insert mode
-- if list item empty or empty todo then clear current line and <CR>
-- if list item or todo is non empty then <CR> and insert todo notaion
-- FIXME doesn't take into account wrapped lines
function M.handle_carridge_return()
  local action = "a<CR>"

  -- if not in pumvisible
  if api.nvim_call_function('pumvisible', {}) == 0 then
    -- and line is a list item
    local line = api.nvim_get_current_line()
    -- if is todo item
    if is_line_todo_item(line) then
      -- if empty clear line
      if line:match("^%s*[*-]%s?%[[%sox]%]%s?$") then
        api.nvim_set_current_line("")
      else
        -- add emptry todo item to line
        action = "a<CR>[ ] "
      end
    -- if empty comment then clear line
    elseif line:match("^%s*[*-]%s*$") then
      api.nvim_set_current_line("")
    end
  else
    action = "<CR>"
  end

  -- action = "<cr>what"
  M.nvim_escaped_command("normal! " .. action)
end

-- TODO refactor into helper module
function M.nvim_escaped_command(command)
  vim.api.nvim_command(vim.api.nvim_replace_termcodes(command, true, false, true))
end

function M.buf_get_line_above_below(is_below)
  local previous_line_nr, _ = unpack(vim.api.nvim_win_get_cursor(0))

  if is_below then
    -- get line above
    previous_line_nr = previous_line_nr - 1
  else
    -- get line below
    previous_line_nr = previous_line_nr + 1
  end

  -- Capture line o/O was triggered from
  return vim.api.nvim_buf_get_lines(0, previous_line_nr - 1, previous_line_nr, false)[1]
end

-- luaeval("require('markdown.todo').insert_empty_todo_box(true)")
--
-- To be used after build in o/O in normal mode
-- Checks if in a todo todo and adds a new empty todo item notation
-- after */- todo notation
function M.insert_empty_todo_box(is_below)
  local previous_line = M.buf_get_line_above_below(is_below)

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
