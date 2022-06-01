local log = require("util.log")

---Define vim user command
---@param name string
---@param command string | function
---@param opts? table
local function user_command(name, command, opts)
  local options = { force = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_create_user_command(name, command, options)
end

user_command("ShowHighlightGroup", require("util.config").show_highlight_group)
user_command("SetProjectCWD", require("util.path").set_cwd_to_project_root)
-- some filesystem helpers
user_command("Mkdir", "lua require('util.filesystem').mkdir(<args>)", {
  nargs = "?",
  complete = "dir",
})
user_command("SetCWDToBuffer", "cd %:p:h")
user_command("IntelliJ", "lua require('config.intellij-mappings')")
