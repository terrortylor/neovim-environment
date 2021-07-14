-- TODO look at some pcall wrapping so everthing doesn't break if single error
local util = require('util.config')

local autogroups = {
  cursor_line_group = {
    {"WinEnter", "*", "setlocal cursorline"},
    {"WinLeave", "*", "setlocal nocursorline"}
  },
  remove_trailing_whitespace = {
    -- FIXME this moves the cursor, so need to set mark and jump back
    {"BufWritePre", "*", [[%s/\s\+$//e]]}
  },
  return_to_last_edit_in_buffer = {
    {"BufReadPost", "*", "lua require('ui.buffer').move_to_last_edit()"}
  },
}

util.create_autogroups(autogroups)
