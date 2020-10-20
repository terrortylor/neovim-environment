local api = vim.api
local loop = vim.loop
local util = require('util.config')
local parser = require('restclient.parser')
local draw = require('ui.window.draw')
local log = require('util.log')
-- LOG_LEVEL = "DEBUG"
local M = {}

local requests = nil
local result_buf = nil
-- TODO move to func
  local results = {}

local function clear_result_buf(inc_results)
  api.nvim_buf_set_lines(
  result_buf,
  0,
  api.nvim_buf_line_count(result_buf),
  false,
  {}
  )
  if inc_results then results = {} end
end

-- FIXME this needs to be a queue
local function update_result_buf()
  clear_result_buf(false)
  api.nvim_buf_set_lines(
  result_buf,
  api.nvim_buf_line_count(result_buf),
  api.nvim_buf_line_count(result_buf),
  false,
  results
  )
end


local function create_result_scratch_buf()
  if result_buf then
    clear_result_buf(true)
  else
    -- create unlisted scratch buffer
    result_buf = api.nvim_create_buf(false, true)
    -- TODO set not modifiable
  end
end

local function on_read_callback(err, data)
  if err then
    -- TODO handle err
    table.insert(results, "Error")
  end
  if data then
    local vals = vim.split(data, "\n")
    for _, d in pairs(vals) do
      if d == "" then goto continue end
      table.insert(results, d)
      ::continue::
    end
  end
end

local function async_run_curl(request, next_id, callback)
  local curl_args = request:get_curl()

  local stdout = vim.loop.new_pipe(false)
  local stderr = vim.loop.new_pipe(false)

  log.debug("Running cUrl: curl " .. curl_args)
  -- log.debug(vim.inspect(vim.split(curl_args, ' ')))

  -- TODO move to func, request would benefit from being class
  if next_id > 1 then
    table.insert(results, "")
  end
  table.insert(results, "##########")
  table.insert(results, "# " .. request:get_title())
  table.insert(results, "")

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

        update_result_buf()
  callback(next_id)
      end
    )
  )
  vim.loop.read_start(stdout, on_read_callback)
  vim.loop.read_start(stderr, on_read_callback)
end

function M.run_next(i)
  if requests then
    local request = requests[i]

    if request then
      async_run_curl(request, i +1, M.run_next)
    end
  end
end

function M.run()
  local buf = api.nvim_win_get_buf(0)
  local filetype = api.nvim_buf_get_option(0, 'filetype')

  if filetype == 'rest' then
    local buf_lines = api.nvim_buf_get_lines(buf, 0, api.nvim_buf_line_count(buf), false)
    requests = parser.parse_lines(buf_lines)

    create_result_scratch_buf()

    draw.open_draw(result_buf)

    M.run_next(1)
  else
    log.error('Must be filetype: rest')
  end
end

function M.setup()
  command = {
    'command!',
    '-nargs=0',
    'RestclientRunFile',
    "call luaeval('require(\"restclient\").run()', expand('<args>'))"
  }
  api.nvim_command(table.concat(command, ' '))

  local autogroups = {
    rest_filetype_detect = {
      {"BufNewFile,BufRead", "*.rest", "set filetype=rest"}
    }
  }

  util.create_autogroups(autogroups)
end

return M
