local filesystem = require("util.filesystem")
local api = vim.api

local M = {}

-- TODO don't really use this
--- Wipes a buffer and then deletes the file from disk
-- @param path string the buffer to remove, this is the path in :ls
--                    if empty then it uses the buffer value
function M.delete_file(path)
  path = path or api.nvim_call_function("expand", {"%:p"})
  vim.cmd("bwipeout! " .. path)
  filesystem.delete(path)
end

-- TODO defo not used, ned to finish
--- Renames a file on disk, then reloads the file in to the buffer list
-- @param path string the buffer to rename, this is the path in :ls
--                     if empty it uses the buffer value
function M.rename_file(path)
  path = path or api.nvim_call_function("expand", {"%:p"})
  vim.cmd("bwipeout! " .. path)
  filesystem.delete(path)
end

--- Creates a directory, linux only
-- @param path string the path to create, if nil then uses path of current buffer
function M.mkdir(path)
  path = path or api.nvim_call_function("expand", {"%:p:h"})
  os.execute("mkdir -p " .. path)
end

return M
