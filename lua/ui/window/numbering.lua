local M = {}

-- TODO this is duplicated in statusline
-- TODO this should not be hard codded?
local ignore_filetypes = {
  "qf",
  "help",
  "TelescopePrompt",
  "NvimTree",
  "lspinfo",
  "packer"
}

function M.win_enter()
  local filetype = vim.api.nvim_buf_get_option(0, "filetype")
  if filetype == "" then
    return
  end

  for _,ft in pairs(ignore_filetypes) do
    if ft == filetype then
      return
    end
  end

  vim.wo.relativenumber = true
end

function M.win_leave()
  local filetype = vim.api.nvim_buf_get_option(0, "filetype")
  if filetype == "" then
    return
  end

  for _,ft in pairs(ignore_filetypes) do
    if ft == filetype then
      return
    end
  end

  vim.wo.relativenumber = false
end

function M.cmd_enter()
  vim.o.relativenumber = false
  vim.cmd('redraw')
end

function M.cmd_leave()
  local filetype = vim.api.nvim_buf_get_option(0, "filetype")
  if filetype == "" then
    return
  end

  for _,ft in pairs(ignore_filetypes) do
    if ft == filetype then
      return
    end
  end

  vim.o.relativenumber = true
  vim.cmd('redraw')
end

return M
