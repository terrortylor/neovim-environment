-- TODO look at some pcall wrapping so everthing doesn't break if single error
local util = require('util.config')

local autogroups = {
  cursor_line_group = {
    {"WinEnter", "*", "setlocal cursorline"},
    {"WinLeave", "*", "setlocal nocursorline"}
  },
  vim_rc_auto_write = {
    -- FIXME call function that only runs update if file exists, i.e. not new
    {"InsertLeave,TextChanged", "*", ":update"}
  },
  remove_trailing_whitespace = {
    {"BufWritePre", "*", [[%s/\s\+$//e]]}
  },
  -- FIXME this loads on filetype correctly
  -- but fun is unable to set buffer options
  lua_filetype_loading = {
    {"VimEnter,FileType", "*", "lua require('config.function.filetype').load_filetype_config()"}
  },
  return_to_last_edit_in_buffer = {
    {"BufReadPost", "*", "lua require('config.function.autocommands').move_to_last_edit()"}
  },
}

util.create_autogroups(autogroups)
