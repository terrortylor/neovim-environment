local api = vim.api
local log = require("util.log")
local M = {}

function M.exit(lines)
  -- TODO shoudl the
  --  local errfmt = api.nvim_buf_get_option(0, "errorformat")
  --  aip.nvim_call_function("setqflist", {{}, "r", {title = "TestRunner Results", lines = lines, efm = errfmt}})
  if #lines > 0 then
    api.nvim_call_function("setqflist", {{}, "r", {title = "TestRunner Results", lines = lines}})
    vim.cmd("doautocmd QuickFixCmdPost")
    vim.cmd("cwindow")
  end
end

function M.run(command, args)
  if not command then
    log.debug("Test runner: command nil")
    return
  end

  if not args then
    log.debug("Test runner: args nil")
    return
  end

  log.info("Tests Running")

  local stdout = vim.loop.new_pipe(false)
  local stderr = vim.loop.new_pipe(false)

  local lines = {}

  local callback = function(err, data)
    if err then
      log.error("Error in command response")
      log.debug(err)
    end

    if data then
      for _,line in pairs(vim.split(data, "\n")) do
        table.insert(lines, line)
      end
    end
  end

  -- TODO move to func, request would benefit from being class
  local handle
  handle = vim.loop.spawn(command, {
    args = args,
    stdio = {stdout,stderr}
  },
  vim.schedule_wrap(function()
    stdout:read_stop()
    stderr:read_stop()
    stdout:close()
    stderr:close()
    handle:close()
    M.exit(lines)
    log.info("Tests Complete")
  end
  )
  )
  vim.loop.read_start(stdout, vim.schedule_wrap(callback))
  vim.loop.read_start(stderr, vim.schedule_wrap(callback))
end

return M
