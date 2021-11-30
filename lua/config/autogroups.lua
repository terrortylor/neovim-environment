-- TODO look at some pcall wrapping so everthing doesn't break if single error
local util = require('util.config')

local autogroups = {
  cursor_line_group = {
    {"WinEnter", "*", "setlocal cursorline"},
    {"WinLeave", "*", "setlocal nocursorline"}
  },
  line_numbers = {
    {"WinEnter", "*", "lua require('ui.window.numbering').win_enter()"},
    {"WinLeave", "*", "lua require('ui.window.numbering').win_leave()"},
    {"CmdLineEnter", "*", "lua require('ui.window.numbering').cmd_enter()"},
    {"CmdLineLeave", "*", "lua require('ui.window.numbering').cmd_leave()"},
  },
  remove_trailing_whitespace = {
    -- FIXME this moves the cursor, so need to set mark and jump back
    {"BufWritePre", "*", [[%s/\s\+$//e]]}
  },
  return_to_last_edit_in_buffer = {
    {"BufReadPost", "*", "lua require('ui.buffer').move_to_last_edit()"},
  },
  highlight_on_yank = {
    {"TextYankPost", "*", "silent! lua vim.highlight.on_yank()"},
  },
}

util.create_autogroups(autogroups)
