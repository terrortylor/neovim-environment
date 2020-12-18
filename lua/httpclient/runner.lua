local M = {}

local requests_complete
local requests_failed

function M.async_curl(request, variables, update_status_cb, update_result_cb)
  local curl_args = request:get_curl(variables)
  if not curl_args then
--    print("curl is nil")
    return
  end
  request:set_running()

  local stdout = vim.loop.new_pipe(false)
  local stderr = vim.loop.new_pipe(false)

  local callback = function(err, data)
    request:set_done()
    if err then
      -- TODO handle err
      request:add_result_line("ERROR")
      if data then
        request.result = data
      end
      requests_failed = requests_failed + 1
    end
    if data then
      request.result = data
      requests_complete = requests_complete + 1
    end
    update_status_cb()
  end

  -- TODO move to func, request would benefit from being class
  local handle
  handle = vim.loop.spawn('curl', {
      args = vim.split(curl_args, ' '),
      stdio = {stdout,stderr}
    },
    vim.schedule_wrap(function()
        stdout:read_stop()
        stderr:read_stop()
        stdout:close()
        stderr:close()
        handle:close()

        -- TODO first three arguments shouldn't be hard coded
        update_result_cb()
      end
    )
  )
  vim.loop.read_start(stdout, vim.schedule_wrap(callback))
  vim.loop.read_start(stderr, vim.schedule_wrap(callback))
end

function M.is_complete(requests)
  local is_complete = true
  for _,req in pairs(requests) do
    if req:queued() then
      is_complete = false
      break
    end
  end
  return is_complete
end

function M.make_requests(requests, variables, status_handler, view_handler)
  -- some variables for tracking state
  local running = true
  local num_requests = #requests
  local requests_missing_data = 0

  requests_complete = 0
  requests_failed = 0

  -- bind callback with args to single func with no args
  local update_status = function()
    status_handler(running, num_requests, requests_complete, requests_missing_data, requests_failed)
  end

  local update_view = function()
    view_handler(requests)
  end

  update_status()
  repeat
    for i = 1, #requests do
      local request = requests[i]

      if request:queued() then
        M.async_curl(request, variables, update_status, update_view)
      end

      if request:missing_data() then
        requests_missing_data = requests_missing_data + 1
      end
    end
  until(M.is_complete(requests))
  running = false
end

return M
