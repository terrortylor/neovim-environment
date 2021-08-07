local api = vim.api
local log = require("util.log")

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
    "Lazygit",
    "lua require('ui.lazygit').open()"
  },
  {
    "command!",
    "-nargs=0",
    "LuaTerm",
    "lua require('ui.window.toggle_term').open(99, 'lua')"
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
  {
    "command!",
    "-nargs=0",
    "SetCWDToBuffer",
    "cd %:p:h"
  },
  {
    "command!",
    "-nargs=0",
    "IntelliJ",
    "lua require('config.intellij-mappings')"
  },
}

for _,v in pairs(commands) do
  vim.cmd(table.concat(v, " "))
end


-- Gron transforms JSON to 'discrete assignments to make it easier to grep'
-- essentially flatterns in. Woth noting that it doesn't presrve original order but
-- useful to for exploring a json file.
if api.nvim_call_function("executable", {"gron"}) > 0 then
  local gron_commands = {
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
  }

  for _,v in pairs(gron_commands) do
    vim.cmd(table.concat(v, " "))
  end
else
  log.error("gron not found on command line, no Gron commands created")
end
