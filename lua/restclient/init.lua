local api = vim.api
local loop = vim.loop
local parser = require('restclient.parser')
local builder = require('restclient.builder')
local draw = require('ui.window.draw')
local log = require('util.log')
  LOG_LEVEL = "DEBUG"
local M = {}

  local rest_blocks = nil
local result_buf = nil
-- TODO move to func
  local results = {}

local function clear_result_buf(inc_results)
  print("clearing")
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
  print("in update_results_buf " .. api.nvim_buf_line_count(result_buf))
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
    -- print('ERROR: ', err)
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

local function async_run_curl(rest, next_id, callback)
  print("run_curl: " .. vim.inspect(rest))
  local curl_args = builder.build_curl(rest)

  local stdout = vim.loop.new_pipe(false)
  local stderr = vim.loop.new_pipe(false)

  log.debug("Running cUrl: curl " .. curl_args)
  -- log.debug(vim.inspect(vim.split(curl_args, ' ')))

  -- TODO move to func, request would benefit from being class
  if next_id > 1 then
    table.insert(results, "")
  end
  table.insert(results, "##########")
  if rest.verb then
    table.insert(results, "# " .. rest.verb[1] .. " - ".. rest.url[1])
  else
    table.insert(results, "# GET - ".. rest.url[1])
  end
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
  print("in run_next: " .. i)
  if rest_blocks then
    print("  has requests")
    local request = rest_blocks[i]
    if request then
      print("  found request: " .. i)
    async_run_curl(request, i +1, M.run_next)
    end
  end
end

function M.run()
  local buf = api.nvim_win_get_buf(0)
  -- TODO add check to ensure correct filetype
  local buf_lines = api.nvim_buf_get_lines(buf, 0, api.nvim_buf_line_count(buf), false)
  rest_blocks = parser.parse_lines(buf_lines)

  create_result_scratch_buf()

  draw.open_draw(result_buf)

  M.run_next(1)
  -- for _,v in pairs(rest_blocks) do
  --   async_run_curl(v)
  -- end
end

return M
