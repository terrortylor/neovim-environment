local api = vim.api

local M = {}

M.defaults = {
  close_mappings = { "<ESC>", "<CR>", "q" },
}

local window_id

--- Takes git blame results and returns results in table
-- For each line in the result parse to return author, date
-- and commit_id in a table
-- @param string result from nvim_command_output
function M.convert_and_format_result(blame_results)
  local blame_lines = {}
  if blame_results then
    for line in blame_results:gmatch("[^\r\n]+") do
      local _, _, commit_id, user, date = string.find(line, "(%w+).*%((.*)%s(%d+-%d+-%d+%s%d+:%d+:%d+).*%+")
      -- only add to result if values found, this is essentiall to skip first line which it the command run
      if commit_id then
        local blame_line = user .. " " .. date .. " " .. commit_id
        table.insert(blame_lines, blame_line)
      end
    end
  end

  return blame_lines
end

--- Executes git blame with given values, returns raw result
-- Should be noted the nvim_command output includes the command being run
-- @param file_name file to run blame on
-- @param line_start the first line to get blame resutls for
-- @param line_end the last line to get blame results for
function M.get_blame_results(file_name, line_start, line_end)
  local command = "!git blame -L " .. line_start .. "," .. line_end .. " " .. file_name
  local result_string = api.nvim_command_output(command)
  return result_string
end

--- Closes the git blame floating window
-- Called from either an autocommand or a buffer mapping
-- Checks to make sure window ID is valid first
function M.close_window()
  if window_id then
    if api.nvim_win_is_valid(window_id) then
      api.nvim_win_close(window_id, true)
    end
  end

  window_id = nil
end

--- Creates the buffer and floating window used to show git blame results
-- Displays float on cursor location, setting width and height to be the max
-- width and sixe of lines map
-- Also creates a numberof mappings to close the window based on lhs_mappins table
-- @param lines lines to be displayed in buffer
-- @param row row to show float on
-- @param col column to show float on
-- @param lhs_mappings list of LHS key map values to map to closing the floating window
function M.create_window(lines, row, col, lhs_mappings)
  local max_width = 0
  for _, v in ipairs(lines) do
    if string.len(v) > max_width then
      max_width = string.len(v)
    end
  end

  local buf = api.nvim_create_buf(false, true)

  api.nvim_buf_set_option(buf, "bufhidden", "wipe")
  api.nvim_buf_set_option(buf, "filetype", "gitblame")
  api.nvim_buf_set_lines(buf, 0, -1, true, lines)
  for _, v in pairs(lhs_mappings) do
    api.nvim_buf_set_keymap(buf, "n", v, "<CMD>lua require('git.blame').close_window()<CR>", { noremap = true })
  end
  vim.cmd("autocmd WinLeave <buffer=" .. buf .. "> ++once :lua require('git.blame').close_window()")

  local opts = {
    style = "minimal",
    row = -1,
    col = 0,
    width = max_width,
    height = table.getn(lines),
    relative = "win",
    bufpos = { row, col },
    focusable = false,
  }

  local win = api.nvim_open_win(buf, true, opts)
  api.nvim_buf_set_option(buf, "modifiable", false)
  window_id = win
end

--- Main hook, used for running git blame
-- Ensures that a single instance of it is running, otherwise escapes
-- @param line_start first line to show blame for
-- @param line_end last line to show blame for
-- @param close_mappings a list of lhs values to map to the close_window function
function M.go(line_start, line_end, close_mappings)
  -- Only want a single blame hover window, otherwise we get strays!
  if window_id then
    return
  end

  -- TODO is full path good, or relative from git home?
  local file_name = api.nvim_call_function("expand", { "%:p" })
  local blame_results = M.get_blame_results(file_name, line_start, line_end)
  local blame_lines = M.convert_and_format_result(blame_results)
  if #blame_lines > 0 then
    local _, cursor_column = unpack(api.nvim_win_get_cursor(0))
    M.create_window(blame_lines, line_start, cursor_column, close_mappings)
  else
    print("GitBlame: File not tracked")
  end
end

function M.set_window_id(id)
  window_id = id
end

--- Used to setup the plugin, sets up commands etc
function M.setup()
  vim.api.nvim_create_user_command("GitBlame", function(params)
    M.go(params.line1, params.line2, M.defaults.close_mappings)
  end, { range = true, force = true })
end

return M
