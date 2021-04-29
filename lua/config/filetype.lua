local api = vim.api
local log = require('util.log')

local M = {}

-- FIXME move to generall utils
local function file_check(file_name)
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
  vim_config_path = vim_config_path:gsub("/init.vim$", "")
  local ftfile_path = string.format("%s/ftplugin/%s.lua", vim_config_path, filetype)
  api.nvim_command("edit " .. ftfile_path)
end

function M.load_filetype_config()
  local filetype = api.nvim_buf_get_option(0, "filetype")
  if not filetype or filetype == "" then
    return
  end

  -- TODO must be a nicer way that this, but XDG_CONFIG_HOME isn't always set
  local vim_config_path = os.getenv("XDG_CONFIG_HOME")
  if not vim_config_path then
    vim_config_path = api.nvim_eval("expand('$MYVIMRC')"):gsub("/init.lua$", "")
  end
  local ftfile_path = string.format("%s/ftplugin/%s.lua", vim_config_path, filetype)
  log.debug("Filetype to be loaded: " .. ftfile_path)
  if file_check(ftfile_path) then
    api.nvim_command("luafile " .. ftfile_path)
  end
end

return M
