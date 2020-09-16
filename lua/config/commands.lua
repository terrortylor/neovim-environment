local api = vim.api

api.nvim_command("command! -nargs=0 OpenFTPluginFile lua require('config.function.filetype').open_ftplugin_file()")
