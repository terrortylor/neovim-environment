local api = vim.api
local M = {}
local table_utils = require('util.table')


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
      end
    end
  end

  win = nil
  border_win = nil
end

function M.gen_centered_float_opts(width_percent, height_percent)
  local width = api.nvim_get_option("columns")
  local height = api.nvim_get_option("lines")

  local win_width = math.ceil(width * width_percent)
  local win_height = math.ceil(height * height_percent)

  local col = math.ceil((width - win_width) / 2)
  local row = math.ceil((height - win_height) / 2 - 1)

  local opts = {
    style = "minimal",
    relative = "editor",
    width = win_width,
    height = win_height,
    row = row,
    col = col
  }

  return opts
end

function M.open_float(buf, has_border, title, opts)
  title = title or ""
  local border_win, win

  if has_border then
    local border_buf = api.nvim_create_buf(false, true)
    api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')

    local border_opts = table_utils.shallow_copy(opts)
    border_opts.width = border_opts.width + 2
    border_opts.height = border_opts.height + 2
    border_opts.row = border_opts.row - 1
    border_opts.col = border_opts.col - 1

    local border_lines = { '╔' .. center(title, opts.width, '═') .. '╗' }
    local middle_line = '║' .. string.rep(' ', opts.width) .. '║'
    for i=1, opts.height do
      table.insert(border_lines, middle_line)
    end
    table.insert(border_lines, '╚' .. string.rep('═', opts.width) .. '╝')
    api.nvim_buf_set_lines(border_buf, 0, -1, false, border_lines)

    border_win = api.nvim_open_win(border_buf, true, border_opts)

    api.nvim_command('autocmd BufWipeout <buffer> exe "silent bwipeout! "'..border_buf)
  end


  win = api.nvim_open_win(buf, true, opts)

  -- TODO pass in extra mapping
  -- for _, v in pairs(lhs_mappings) do
  --   api.nvim_buf_set_keymap(buf, "n", v, "<CMD>lua require('git.lib.blame').close_window()<CR>", { noremap = true })
  -- end
  if has_border then
  local command = {
    "autocmd",
    "WinLeave",
    "<buffer=" .. buf .."> ++once",
    ":lua require('util.window.float').close_windows(" .. win .. ", " .. border_win .. ")"
  }
  api.nvim_command(table.concat(command, " "))
  else
  local command = {
    "autocmd",
    "WinLeave",
    "<buffer=" .. buf .."> ++once",
    ":lua require('util.window.float').close_windows(" .. win .. ")"
  }
  api.nvim_command(table.concat(command, " "))
  end
end

return M
