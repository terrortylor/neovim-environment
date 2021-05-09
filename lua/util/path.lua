local api = vim.api
local log = require("util.log")

local M = {}

-- TODO add tests
--- Func to be wrapped in coroutine, iterator logic that on each call
-- returns the stem of the path minus on elemetn up to root.
-- i.e. /a/test/path -> /a/test -> /a
-- it also returns if the returned value is a project root, i.e. .git
-- directory is found, if project directory found then it ends
-- @param path string a path to iterate through, looking for project root marker
-- @return boolean, string is project root and the path minus last element
function M.get_next_element(path)
  local buf_path = path

  local link_path
  local exists

  repeat
    link_path = buf_path .. "/.git"
    exists = api.nvim_call_function("isdirectory", {link_path})

    if exists > 0 then
      break
    end

    coroutine.yield(false, buf_path)
    buf_path = buf_path:match("(.*)/.+")
  until ( not buf_path or buf_path == "/" )

  -- Pattern match removes final '/' so
  -- set it and guard against nil
  if  not buf_path or buf_path == "" then
    buf_path = "/"
  end

  coroutine.yield(exists > 0, buf_path)
end

-- TODO add tests
--- Iterator function use dto step through each element in given path
-- @param path string a path to iterate through, looking for project root marker
-- @return boolean, string is project root and the path minus last element
function M.path_elements(path)
  return coroutine.wrap(function() M.get_next_element(path) end)
end

-- TODO add tests
--- Returns the path of the project root for path given, a project
-- root is defined by a .git directory
-- @param path string a path
-- @return string or nil the found project root path or nil if not found
function M.get_project_root(path)
  local root = nil
  for i,v in M.path_elements(path) do
    if i then
      root = v
    end
  end
  return root
end

--- Looks for a project root marker (.git dir) and if found sets the
-- current working directory (CWD) to found path
function M.set_cwd_to_project_root()
  local cwd = api.nvim_call_function("getcwd", {})
  local root = M.get_project_root(cwd)
  if not root then
    log.error("No project root marker found")
    return
  end

  vim.cmd("cd " .. root)
end

return M
