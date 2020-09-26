local api = vim.api
local float = require('util.window.float')
local M = {}

M.tasks_file = "/home/alextylor/personnal-workspace/notes/tasks.md"

local function load_tasks_buffer()
  local buf = api.nvim_call_function("bufnr", {M.tasks_file, true})
  api.nvim_buf_set_option(buf, "buflisted", true)
  api.nvim_buf_set_option(buf, 'filetype', 'markdown')
  return buf
end

function M.tasks()
  local buf = load_tasks_buffer()
  local opts = float.gen_centered_float_opts(0.8, 0.8)
  float.open_float(buf, true, "Tasks", opts)
end

function M.setup()
  -- TODO allow an argument to open a specific file
  -- TODO allow argument to say from command line so auto close vim when leave window
  local command = {
    "command!",
    "-nargs=0",
    "Tasks",
    "lua require('pa').tasks()"
  }
  api.nvim_command(table.concat(command, " "))
end

return M
