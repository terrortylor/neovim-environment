local api = vim.api
local M = {}

  --TODO args shouldn't be passed here
function M.run_all_tests(args)
  return args
end

  --TODO args shouldn't be passed here
function M.run_file(args)
  local new_args = {unpack(args)}
  -- TODO path shouldn't be absaloute, relative is fine
  local path = api.nvim_call_function("expand", {"%:p"})
  table.insert(new_args, path)
  return new_args
end

  --TODO args shouldn't be passed here
function M.run_closest(args)
  local new_args = M.run_file(args)
  -- capture frist it and desc until top of page
  local buf = api.nvim_win_get_buf(0)
  local linenr,_ = unpack(api.nvim_win_get_cursor(0))
  local found_it = false
  local found_desc = false
  local filter = ""
  repeat
    local line = api.nvim_buf_get_lines(buf, linenr - 1, linenr, false)[1]

    local match = line:match(".*describe%s*%(%s*[\"'](.*)[\"']%,")
    if match then
      filter = match .. " " .. filter
      found_it = true
    else
      match = line:match(".*it%s*%(%s*[\"'](.*)[\"']%,")
      if match then
        filter = match
        found_desc = true
      end
    end

    linenr = linenr - 1
  until(linenr == 0 or (found_it and found_desc))
  table.insert(new_args, "--filter")
  table.insert(new_args, filter)
  return new_args
end

return M
