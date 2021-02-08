-- TODO look at some pcall wrapping so everthing doesn't break if single error
local util = require('util.config')

local autogroups = {
  cursor_line_group = {
    {"WinEnter", "*", "setlocal cursorline"},
    {"WinLeave", "*", "setlocal nocursorline"}
  },
  vim_rc_auto_write = {
    -- FIXME call function that only runs update if file exists, i.e. not new
    {"InsertLeave,TextChanged", "*", "lua require('config.function.filesystem').update_buffer()"}
  },
  remove_trailing_whitespace = {
    -- FIXME this moves the cursor, so need to set mark and jump back
    {"BufWritePre", "*", [[%s/\s\+$//e]]}
  },
  -- TODO move this auto comand to filetype file, so it's self contianed, then all from config/init.lua
  lua_filetype_loading = {
    {"VimEnter,FileType", "*", "lua require('config.filetype').load_filetype_config()"}
  },
  return_to_last_edit_in_buffer = {
    {"BufReadPost", "*", "lua require('config.function.autocommands').move_to_last_edit()"}
  },
}

util.create_autogroups(autogroups)
