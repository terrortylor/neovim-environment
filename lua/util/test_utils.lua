local M = {}

function M.multiline_to_table(s)
    local t = {}
    for l in s:gmatch('(.-)\n') do
        table.insert(t, l)
    end
    return t
end

-- TODO this is duplicated move to helper func
function M.load_lines(lines)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(buf, 'filetype', 'markdown')
  vim.cmd("sbuffer " .. buf)

  vim.api.nvim_buf_set_lines(0, 0, -1, true, M.multiline_to_table(lines))

  return buf
end

function M.buf_get_lines()
  local result = vim.api.nvim_buf_get_lines(
  0, 0, vim.api.nvim_buf_line_count(0), false
  )
  return result
end

function M.buf_as_multiline()
  local lines = M.buf_get_lines()
  local s = ""
  for _,l in pairs(lines) do
    s = s .. l .. '\n'
  end
  return s
end

-- TODO this is duplicated move to helper func
function M.send_keys(keys)
  -- TODO can we use nvim_input here?
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), "x", false)
end

return M
