local api = vim.api
local view = require('test-runner.view')
local Job = require("plenary.job")
local M = {}

local lines = {}

function M.update_quickfix(errorformat)
  -- change this to local list?
  if #lines > 0 then
    api.nvim_call_function("setqflist", {{}, "r", {title = "TestRunner Results", lines = lines, efm = errorformat}})
    vim.cmd("doautocmd QuickFixCmdPost")
    vim.cmd("cwindow")
  else
    -- TODO close list
  end
end

function M.get_output()
  return lines
end

function M.run(command, args, errorformat, std_cb)
  lines = {}

  local gg = Job:new {
        command = command,
        args = args,

        -- Can be turned on to debug
        on_stdout = function(_, data)
          for _,line in pairs(vim.split(data, "\n")) do
            table.insert(lines, line)
          end
          std_cb(data)
        end,

        on_stderr = function(_, data)
          for _,line in pairs(vim.split(data, "\n")) do
            table.insert(lines, line)
          end
          view.schedule_add_lines(data)
        end,

        on_exit = vim.schedule_wrap(function(_, _, _)
          -- TODO show view status line update
          M.update_quickfix(errorformat)
        end)
      }
      --TODO show view status line update
      gg:start()
end

return M
