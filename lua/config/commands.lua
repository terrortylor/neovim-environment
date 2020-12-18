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
  {
    "command!",
    "-nargs=0",
    "SetProjectCWD",
    "lua require('util.path').set_cwd_to_project_root()"
  },
  -- gron
  {
    "command!",
    "-nargs=0",
    "Gron",
    "%!gron"
  },
  {
    "command!",
    "-nargs=0",
    "UnGron",
    "%!gron --ungron"
  },
  -- some filesystem helpers
  {
    "command!",
    "-nargs=?",
    "-complete=buffer",
    "DeleteFile",
    "lua require('config.function.filesystem').delete_file(<args>)"
  },
  {
    "command!",
    "-nargs=?",
    "-complete=dir",
    "Mkdir",
    "lua require('config.function.filesystem').mkdir(<args>)"
  },
}
for _,v in pairs(commands) do
  api.nvim_command(table.concat(v, " "))
end
