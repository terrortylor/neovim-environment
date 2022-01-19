-- TODO I don't like the location location/name of this, this is all part of wiki
-- TODO add tests
local api = vim.api
local float = require('ui.window.float')
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

function M.open_markdown_centered_float(title, filename, style)
  local buf = open_markdown_buf(filename)
  local opts = float.gen_centered_float_opts(0.8, 0.8, style)

  local cb = function()
    vim.api.nvim_buf_delete(buf, {force = true})
  end

  float.open_float(buf, opts, cb)
end

function M.remindme_complete()
  local tbl = {}

  local files = api.nvim_call_function("globpath", {M.notes_path .. "/remindme", "*.md", 0})

  if files then
    for l in files:gmatch("[^\r\n]+") do
      table.insert(tbl, l:match(".*/(.+)%.md"))
    end
  end

  return tbl
end

-- TODO add mapping so q in normal mode closes window
function M.remindme(args)
  local reminder = args.args
  local filepath = string.format("%s/remindme/%s.md", M.notes_path, reminder)
  if fs.file_exists(filepath) then
    M.open_markdown_centered_float(string.format(" RemindMe: %s ", reminder), filepath, true)
  else
    log.error("RemindMe - File not found: " .. filepath)
  end
end

function M.setup()
  -- TODO allow argument to say from command line so auto close vim when leave window
  vim.api.nvim_add_user_command("RemindMe", M.remindme, {force = true, nargs=1})
end

return M
