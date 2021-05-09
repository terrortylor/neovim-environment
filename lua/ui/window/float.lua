-- TODO add tests
local api = vim.api
-- TODO vim.deepcopy() is built int, need to get tests running from within vim
local table_utils = require('util.table')

local M = {}

-- map callback function to window to be run when closed
M.callbacks = {}

-- TODO pop up scrath terminal, that is repl for filetype

local function center(str, width, pad_char)
  local shift = math.floor((width - string.len(str)) / 2)
  local r_shift = (width - string.len(str)) - shift
  return string.rep(pad_char, shift) .. str .. string.rep(pad_char, r_shift)
end

function M.close_windows(win, border_win)
  for _,v in pairs({border_win, win}) do
    if v then
      if api.nvim_win_is_valid(v) then
        api.nvim_win_close(v, true)

        local callback = M.callbacks[win]
        if  callback then
          callback()
          M.callbacks[win] = nil
        end
      end
    end
  end
end

function M.gen_centered_float_opts(width_percent, height_percent, style)
  local width = api.nvim_get_option("columns")
  local height = api.nvim_get_option("lines")

  local win_width = math.ceil(width * width_percent)
  local win_height = math.ceil(height * height_percent)

  local col = math.ceil((width - win_width) / 2)
  local row = math.ceil((height - win_height) / 2 - 1)

  local opts = {
    relative = "editor",
    width = win_width,
    height = win_height,
    row = row,
    col = col
  }

  if style then
    opts['style'] = 'minimal'
  end

  return opts
end

function M.open_float(title, has_border, buf, buf_opts, callback)
  callback = callback or function() end
  local border_win, win

  if has_border then
    local border_buf = api.nvim_create_buf(false, true)
    api.nvim_buf_set_option(border_buf, 'bufhidden', 'wipe')

    local border_opts = table_utils.shallow_copy(buf_opts)
    border_opts['style'] = 'minimal'
    border_opts.width = border_opts.width + 2
    border_opts.height = border_opts.height + 2
    border_opts.row = border_opts.row - 1
    border_opts.col = border_opts.col - 1

    local border_lines = { '╔' .. center(title, buf_opts.width, '═') .. '╗' }
    local middle_line = '║' .. string.rep(' ', buf_opts.width) .. '║'
    for _=1, buf_opts.height do
      table.insert(border_lines, middle_line)
    end
    table.insert(border_lines, '╚' .. string.rep('═', buf_opts.width) .. '╝')
    api.nvim_buf_set_lines(border_buf, 0, -1, false, border_lines)

    border_win = api.nvim_open_win(border_buf, true, border_opts)

    -- Cleanup the border buffer
    local command = {
      "autocmd",
      "BufWipeout",
      "<buffer=" .. border_buf .."> ++once",
      "exe 'silent bwipeout! " .. border_buf .. "'"
    }
    vim.cmd(table.concat(command, " "))
  end


  win = api.nvim_open_win(buf, true, buf_opts)
  M.callbacks[win] = callback

  -- TODO pass in extra mapping, such as <sec> or <c-c>
  -- for _, v in pairs(lhs_mappings) do
  --   api.nvim_buf_set_keymap(buf, "n", v, "<CMD>lua require('git.lib.blame').close_window()<CR>", { noremap = true })
  -- end
  -- TODO how is buffer removed from list?
  if has_border then
    local command = {
      "autocmd",
      "WinLeave",
      "<buffer=" .. buf .."> ++once",
      ":lua require('ui.window.float').close_windows(" .. win .. ", " .. border_win .. ")"
    }
    vim.cmd(table.concat(command, " "))
    return {win, border_win}
  else
    local command = {
      "autocmd",
      "WinLeave",
      "<buffer=" .. buf .."> ++once",
      ":lua require('ui.window.float').close_windows(" .. win .. ")"
    }
    vim.cmd(table.concat(command, " "))

    return {win, nil}
  end

end

return M
