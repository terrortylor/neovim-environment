local api = vim.api

api.nvim_command("command! -nargs=0 OpenFTPluginFile lua require('config.function.filetype').open_ftplugin_file()")

api.nvim_command("command! -nargs=0 ShowHighlightGroup lua require('util.config').show_highlight_group()")
