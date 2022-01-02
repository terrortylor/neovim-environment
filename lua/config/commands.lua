local log = require("util.log")
local user_command = require("util.config").user_command

user_command("Lazygit", require('ui.lazygit').open)
user_command("ShowHighlightGroup", require('util.config').show_highlight_group)
user_command("SetProjectCWD", require('util.path').set_cwd_to_project_root)
-- some filesystem helpers
user_command(
  "Mkdir",
  "lua require('util.filesystem').mkdir(<args>)",
  {
    nargs = "?",
    complete = "dir"
  }
)
user_command("SetCWDToBuffer", "cd %:p:h")
user_command("IntelliJ", "lua require('config.intellij-mappings')")


-- Gron transforms JSON to 'discrete assignments to make it easier to grep'
-- essentially flatterns in. Woth noting that it doesn't presrve original order but
-- useful to for exploring a json file.
if vim.api.nvim_call_function("executable", {"gron"}) > 0 then
    -- gron
    user_command("Gron", "%!gron")
    user_command("UnGron", "%!gron --ungron")
else
  log.error("gron not found on command line, no Gron commands created")
end
