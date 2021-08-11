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

function M.schedule_add_lines(data)
  vim.schedule_wrap(function(...)
    if not vim.api.nvim_buf_is_valid(M.result_buf) then
      return
    end

    for _, v in ipairs({...}) do
      vim.api.nvim_buf_set_lines(M.result_buf, -1, -1, false, {v})
    end
  end)(data)
end

-- TODO rename to create_result_buf
-- TODO change filetype and title
-- TODO this should be scopped per tab
function M.create_result_scratch_buf()
  if M.result_buf then
    M.clear_result_buf(true)
  else
    -- create unlisted scratch buffer
    M.result_buf = api.nvim_create_buf(false, true)
    -- if nvim-colorizer is set then it should pick up ther terminal colour codes
    api.nvim_buf_set_option(M.result_buf, "filetype", "terminal")
    api.nvim_buf_set_name(M.result_buf, 'Test Results')
    -- TODO set not modifiable
  end
end

return M

