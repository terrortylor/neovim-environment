local api = vim.api

local commands = {
  {
    "command!",
    "-nargs=0",
    "OpenFTPluginFile",
    "lua require('config.function.filetype').open_ftplugin_file()"
  },
  {
    "command!",
    "-nargs=0",
    "ShowHighlightGroup",
    "lua require('util.config').show_highlight_group()"
  },
}
for _,v in pairs(commands) do
  api.nvim_command(table.concat(v, " "))
end
