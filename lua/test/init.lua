--- A poor mans test runner, supports the following strategies:
-- * Run all tests
-- TODO update current to find current file's test file, can use alternate package
-- * Run current file
-- * Run closest - this is cheap, just looks up the file
-- * Last - the last stategy run
local api = vim.api
local log = require("util.log")
local runner = require("test.runner")
local M = {}

M.filetype = {
  lua = {
    {
      rule = "/lua/",
      command = "busted",
      args = {"-m", "./lua/?.lua;./lua/?/?.lua;./lua/?/init.lua"}
    }
  }
}

local commands = {
  TestRunAll = "run_all_tests",
  TestFile    = "run_file",
  TestClosest = "run_closest",
  TestLast = "run_last",
}

local last_run

local function get_filetype_module(filetype)
  local result, ft_args = pcall(require, "test.filetypes." .. filetype)
  if not result then
    log.error("No filetype ft_args found")
    return nil
  end
  return ft_args
end

-- TODO this could be done in a meta table with single func
function M.run(strategy)
 local filetype = api.nvim_buf_get_option(0, 'filetype')
 local configs = M.filetype[filetype]
 if not configs then
   log.error("No test ft_args config found for filetype")
   return
 end

 local path = api.nvim_call_function("expand", {"%:p"})
 for _,config in pairs(configs) do
   if path:match(config.rule) then
     local ft_args = get_filetype_module(filetype)
     -- overkill safe guard perhaps?
     if not ft_args then return end

     local args
     if strategy == "run_all_tests" then
       args = ft_args.run_all_tests(config.args)
     elseif strategy == "run_file" then
       args = ft_args.run_file(config.args)
     elseif strategy == "run_closest" then
       args = ft_args.run_closest(config.args)
     elseif strategy == "run_last" then
       if not last_run then
         log.error("No tests run yet")
       end
       args = last_run
     else
       log.error("Unsupported strategy")
       return
     end
     last_run = args

     runner.run(config.command, args)
     return
   end
 end
end

function M.setup()
  for k,v in pairs(commands) do
    local command = {
      "command!",
      "-nargs=0",
      k,
      "lua require('test').run('"..v.."')"
    }
    api.nvim_command(table.concat(command, " "))
  end
end

return M
