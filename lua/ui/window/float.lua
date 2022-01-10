-- TODO add tests
local api = vim.api

local M = {}

-- map callback function to window to be run when closed
M.callbacks = {}

-- TODO pop up scrath terminal, that is repl for filetype

function M.close_window(win)
  if win then
    if api.nvim_win_is_valid(win) then
      api.nvim_win_close(win, true)

      local callback = M.callbacks[win]
      if  callback then
        callback()
        M.callbacks[win] = nil
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
    col = col,
    border = "double",
  }

  if style then
    opts['style'] = 'minimal'
  end

  return opts
end

function M.open_float(buf, buf_opts, callback)
  callback = callback or function() end
  local win

  win = api.nvim_open_win(buf, true, buf_opts)
  M.callbacks[win] = callback

  -- TODO pass in extra mapping, such as <sec> or <c-c>,this is an example as per git blame
  -- for _, v in pairs(lhs_mappings) do
  --   api.nvim_buf_set_keymap(buf, "n", v, "<CMD>lua require('git.blame').close_window()<CR>", { noremap = true })
  -- end
  -- TODO how is buffer removed from list?
  local command = {
    "autocmd",
    "WinLeave",
    "<buffer=" .. buf .."> ++once",
    ":lua require('ui.window.float').close_windows(" .. win .. ")"
  }
  vim.cmd(table.concat(command, " "))

  return {win, nil}

end

return M
