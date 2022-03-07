-- TODO add tests and docs
local float = require("ui.window.float")

local M = {}

M.options = {
  default_shell = "bash",
}

local terms = {}

function M.open(n, seed_command, start_insert, ...)
  seed_command = seed_command or "bash"

  local args = { ... }
  local command = table.concat(args, " ")

  local buf = terms[n]
  local new = false

  if not buf then
    buf = vim.api.nvim_create_buf(false, true)
    terms[n] = buf
    new = true
  end

  local opts = float.gen_centered_float_opts(0.8, 0.8, true)
  local win = float.open_float(buf, opts, function() end)

  for _, v in pairs({ "<ESC>", "<CR>", "q" }) do
    vim.api.nvim_buf_set_keymap(
      buf,
      "n",
      v,
      "<CMD>lua require('ui.window.float').close_window(" .. win .. ")<CR>",
      { noremap = true }
    )
  end

  if new then
    local close_toggle_term = function()
      float.close_windows(win)
      vim.api.nvim_buf_delete(buf, { force = true })
      terms[n] = nil
    end

    vim.fn.termopen(seed_command, { on_exit = close_toggle_term })
  end

  if command and command ~= "" then
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes("i" .. command .. "<cr><C-\\><C-n>", true, false, true),
      "n",
      true
    )
  end

  if start_insert then
    vim.api.nvim_feedkeys("i", "n", true)
  end
end

return M
