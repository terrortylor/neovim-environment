local api = vim.api

local M = {}

local result_buf = nil
local requests = {}

-- TODO can requests be access directly?
-- TODO rename if not
function M.set_requests(b,r)
  result_buf = b
  requests = r
end

function M.update()
  local total_lines = 0
  -- need some race condition here, like a queue?
    print('in callback')
  for _,r in pairs(requests) do
    print('in callback item')
  api.nvim_buf_set_lines(
  result_buf,
  total_lines,
  total_lines,
  false,
  {"# " .. r:get_title()}
  -- {"# " .. r:get_title()}
  )
  total_lines = total_lines + 1


  end
end

return M
