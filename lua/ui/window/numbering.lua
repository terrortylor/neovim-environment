local ignore_filetype = require("util.buffer").ignore_filetype

local M = {}

local ignore_if_not_modifiable = { "norg" }

function M.setup()
  local ag = vim.api.nvim_create_augroup("line_numbers", { clear = true })
  vim.api.nvim_create_autocmd("WinEnter", {
    pattern = "*",
    callback = function ()
      if ignore_filetype() then
        return
      end
      if ignore_filetype(ignore_if_not_modifiable) and not vim.bo.modifiable then
        return
      end
      vim.wo.relativenumber = true
    end,
    group = ag,
  })

  vim.api.nvim_create_autocmd("WinLeave", {
    pattern = "*",
    callback = function ()
      if ignore_filetype() then
        return
      end
      vim.wo.relativenumber = false
    end,
    group = ag,
  })

  vim.api.nvim_create_autocmd("CmdLineEnter", {
    pattern = "*",
    callback = function ()
      vim.o.relativenumber = false
      vim.cmd("redraw")
    end,
    group = ag,
  })

  vim.api.nvim_create_autocmd("CmdLineLeave", {
    pattern = "*",
    callback = function ()
      if ignore_filetype() then
        return
      end

      vim.o.relativenumber = true
      vim.cmd("redraw")
    end,
    group = ag,
  })
end

return M
