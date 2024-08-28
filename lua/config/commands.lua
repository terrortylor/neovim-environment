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

-- todo does this actually work?
user_command("ShowHighlightGroup", function()
  local api = vim.api
  local line, col = unpack(api.nvim_win_get_cursor(0))
  local syn_id = api.nvim_call_function("synID", { line, col, 1 })
  if syn_id > 0 then
    local syn_name = api.nvim_call_function("synIDattr", { syn_id, "name" })
    local syn_group_id = api.nvim_call_function("synIDtrans", { syn_id })
    local syn_group_name = api.nvim_call_function("synIDattr", { syn_group_id, "name" })
    print(syn_name .. " -> " .. syn_group_name)
  else
    print("No group info found")
  end
end)

user_command("RemoveTMUXShit", function()
  vim.cmd([[%s/\s*│//]])
  vim.cmd("checktime")
end)

user_command("SetProjectCWD", require("util.path").set_cwd_to_project_root)
-- some filesystem helpers
user_command("Mkdir", "lua require('util.filesystem').mkdir(<args>)", {
  nargs = "?",
  complete = "dir",
})
user_command("SetCWDToBuffer", "cd %:p:h")
user_command("IntelliJ", "lua require('config.intellij-mappings')")


-- some fat finger helpers
user_command("Wa", "wa", {bang = true})
user_command("WA", "wa", {bang = true})
user_command("Q", "q", {bang = true})
user_command("Qa", "qa", {bang = true})
user_command("QA", "qa", {bang = true})
