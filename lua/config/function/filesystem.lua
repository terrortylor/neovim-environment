local filesystem = require("util.filesystem")
local log = require("util.log")
local api = vim.api

local M = {}

--- Wipes a buffer and then deletes the file from disk
-- @param path string the buffer to remove, this is the path in :ls
--                    if empty then it uses the buffer value
function M.delete_file(path)
  path = path or api.nvim_call_function("expand", {"%:p"})
  api.nvim_command("bwipeout! " .. path)
  filesystem.delete(path)
end

--- Renames a file on disk, then reloads the file in to the buffer list
-- @param path string the buffer to rename, this is the path in :ls
--                     if empty it uses the buffer value
function M.rename_file(path)
  path = path or api.nvim_call_function("expand", {"%:p"})
  api.nvim_command("bwipeout! " .. path)
  filesystem.delete(path)
end

--- Saves a buffer if the file path exists (directory path), if the file
-- exists all ready then updates, if the file has no name then do nothing
function M.update_buffer()
  local filename = api.nvim_call_function("expand", {"%"})
  if filename ~= "" then
    local path = api.nvim_call_function("expand", {"%:p:h"})
    if path:match("term://") then
      log.info("Terminal buffer, not saving")
      return
    elseif not filesystem.is_directory(path) then
      log.error("Buffer directory doesn't exit, not saving")
      return
    end
    api.nvim_command(":update")
  end
end

--- Creates a directory, linux only
-- @param path string the path to create, if nil then uses path of current buffer
function M.mkdir(path)
  path = path or api.nvim_call_function("expand", {"%:p:h"})
  os.execute("mkdir -p " .. path)
end

return M
