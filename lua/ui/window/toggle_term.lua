-- TODO add tests and docs
local float = require('ui.window.float')

local M = {}

M.options = {
  default_shell = "bash",
}

local terms = {}

function M.open(n, command, title)
  command = command or "bash"
  title = title or command

  local buf = terms[n]
  local new = false

  if not buf then
    buf = vim.api.nvim_create_buf(false, true)
    terms[n] = buf
    new = true
  end

  local opts = float.gen_centered_float_opts(0.8, 0.8, true)
  local win_tuple = float.open_float(title, true, buf, opts, function() end)

  if new then
    local close_lazygit = function()
      float.close_windows(win_tuple[1], win_tuple[2])
      vim.api.nvim_buf_delete(buf, {force = true})
      terms[n] = nil
    end

    vim.fn.termopen(command, {on_exit = close_lazygit})
  end

  vim.api.nvim_command("startinsert!")
end

return M
