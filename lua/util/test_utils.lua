local M = {}

-- This could be vim.split but actually then the input and expected
-- need to manage different end empty line, this is to readable tests
function M.multiline_to_table(s)
  local t = {}
  for l in s:gmatch("(.-)\n") do
    table.insert(t, l)
  end
  return t
end

function M.buf_from_multiline(lines)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.cmd("sbuffer " .. buf)

  vim.api.nvim_buf_set_lines(0, 0, -1, true, M.multiline_to_table(lines))

  return buf
end

function M.buf_from_table(lines)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.cmd("sbuffer " .. buf)

  vim.api.nvim_buf_set_lines(0, 0, -1, true, lines)

  return buf
end

function M.get_buf_lines()
  local result = vim.api.nvim_buf_get_lines(0, 0, vim.api.nvim_buf_line_count(0), false)
  return result
end

function M.get_buf_as_multiline()
  local lines = M.get_buf_lines()
  local s = ""
  for _, l in pairs(lines) do
    s = s .. l .. "\n"
  end
  return s
end

function M.send_keys(keys)
  -- TODO can we use nvim_input here?
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), "x", false)
end

return M
