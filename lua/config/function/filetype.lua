local api = vim.api
local util = require('util')

local M = {}

-- FIXME move to generall utils
function file_check(file_name)
  local file_found = io.open(file_name, "r")
  return file_found
end

-- TODO refactor these as one opens vim file, one if for lua config and both same code
function M.open_ftplugin_file()
  local filetype = api.nvim_buf_get_option(0, "filetype")
  if not filetype or filetype == "" then
    print("Filetype not set")
    return
  end

  local vim_config_path = api.nvim_eval("expand('$MYVIMRC')")
  local vim_config_path = vim_config_path:gsub("/init.vim$", "")
  local ftfile_path = string.format("%s/ftplugin/%s.vim", vim_config_path, filetype)
  api.nvim_command("edit " .. ftfile_path)
end

function M.load_filetype_config()
  local filetype = api.nvim_buf_get_option(0, "filetype")
  if not filetype or filetype == "" then
    return
  end

  local vim_config_path = api.nvim_eval("expand('$MYVIMRC')")
  local vim_config_path = vim_config_path:gsub("/init.vim$", "")
  local ftfile_path = string.format("%s/lua/filetype/%s.lua", vim_config_path, filetype)
  util.log.debug("Filetype to be loaded: " .. ftfile_path)
  if file_check(ftfile_path) then
    api.nvim_command("luafile " .. ftfile_path)
  end
end

return M
