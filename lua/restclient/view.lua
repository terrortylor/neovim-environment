local api = vim.api

local M = {}

M.result_buf = nil

function M.clear_result_buf()
  api.nvim_buf_set_lines(
  M.result_buf,
  0,
  api.nvim_buf_line_count(M.result_buf),
  false,
  {}
  )
end

function M.add_lines(lines)
  local buf_start = api.nvim_buf_line_count(M.result_buf)
  local buf_end = buf_start

  -- An empty buffer still had 1 line
  if buf_start == 1 then
    buf_start = 0
  end

  api.nvim_buf_set_lines(M.result_buf, buf_start, buf_end, false, lines)
end

function M.update_result_buf(requests)
  M.clear_result_buf()

  for _,req in pairs(requests) do
    M.add_lines({
      '#######################',
      req:get_title()
    })
    M.add_lines(req:get_results())
    M.add_lines({
      '',
    })

  end
end

function M.create_result_scratch_buf()
  if M.result_buf then
    M.clear_result_buf(true)
  else
    -- create unlisted scratch buffer
    M.result_buf = api.nvim_create_buf(false, true)
    -- TODO set not modifiable
  end
end

return M
