local api = vim.api
local float = require('util.window.float')
local fs = require('util.filesystem')
local log = require('util.log')
local M = {}

M.notes_path = "/home/alextylor/personnal-workspace/notes"

local function open_markdown_buf(filename)
  -- TODO use lua/util/buffer function
  local buf = api.nvim_call_function("bufnr", {filename, true})
  api.nvim_buf_set_option(buf, "buflisted", true)
  api.nvim_buf_set_option(buf, 'filetype', 'markdown')

  -- Filetype doesn't seem to pick up the format options so enforce here
  -- FIXME this may be tied to the window style: minimal which there are no other options at the moment
  local fo = api.nvim_buf_get_option(buf, 'formatoptions')
  if not fo:match("o") then
    fo = fo .. "o"
    api.nvim_buf_set_option(buf, 'formatoptions', fo)
  end

  return buf
end

function center_float(filename)
  local buf = open_markdown_buf(filename)
  local opts = float.gen_centered_float_opts(0.8, 0.8)
  float.open_float(buf, true, "Tasks", opts)
end

function M.tasks()
  local filepath = string.format('%s/%s', M.notes_path, 'tasks.md')
  center_float(filepath)
end

function M.remindme(reminder)
  local filepath = string.format("%s/remindme/%s.md", M.notes_path, reminder)
  if fs.file_exists(filepath) then
    center_float(filepath)
  else
    log.error("RemindMe - File not found: " .. filepath)
  end
end

function M.setup()
  -- TODO allow argument to say from command line so auto close vim when leave window
  local commands = {
    {
      "command!",
      "-nargs=0",
      "Tasks",
      "lua require('pa').tasks()"
    },
    {
      -- TODO add completion here that looks in files in directory
      "command!",
      "-nargs=1",
      "RemindMe",
      "lua require('pa').remindme('<args>')"
    },
  }
  for _,v in pairs(commands) do
    api.nvim_command(table.concat(v, " "))
  end
end

return M
