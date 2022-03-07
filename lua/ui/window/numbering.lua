local ignore_filetype = require("util.buffer").ignore_filetype

local M = {}

function M.win_enter()
  if ignore_filetype() then
    return
  end

  vim.wo.relativenumber = true
end

function M.win_leave()
  if ignore_filetype() then
    return
  end
  vim.wo.relativenumber = false
end

function M.cmd_enter()
  vim.o.relativenumber = false
  vim.cmd("redraw")
end

function M.cmd_leave()
  if ignore_filetype() then
    return
  end

  vim.o.relativenumber = true
  vim.cmd("redraw")
end

return M
