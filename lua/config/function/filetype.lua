local api = vim.api

local M = {}

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

return M
