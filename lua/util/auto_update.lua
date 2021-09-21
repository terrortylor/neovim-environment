local filesystem = require("util.filesystem")
local log = require("util.log")
local api = vim.api

local M = {}

M.opts = {
-- TODO this is duplicated in statusline
  blacklist_filetypes = {
  "qf",
  "help",
  "TelescopePrompt",
  "NvimTree",
  "lspinfo"
  }
}

function M.toggle_auto_update()
  vim.g.enable_auto_update = not vim.g.enable_auto_update
  -- TODO this should be a post hook
  vim.cmd("redrawtabline")
end

--- Saves a buffer if the file path exists (directory path), if the file
-- exists all ready then updates, if the file has no name then do nothing
function M.update_buffer()
  -- TODO blacklist filtypes
  if vim.g.enable_auto_update then
    local filename = api.nvim_call_function("expand", {"%"})
    if filename ~= "" then
      local path = api.nvim_call_function("expand", {"%:p:h"})
      if path:match("term://") then
        log.info("Terminal buffer, not saving")
        return
      elseif not filesystem.is_directory(path) then
        log.error("Buffer directory doesn't exit, not saving")
        return
      end

      -- sometimes it's nice to override stuff :P
      local readonly = vim.api.nvim_buf_get_option(0, "readonly")
      if readonly then
        return
      end

      local filetype = vim.api.nvim_buf_get_option(0, "filetype")
      for _,ft in pairs(M.opts.blacklist_filetypes) do
        if ft == filetype then
          return
        end
      end

      -- check if modified then run aucommand?
      if vim.api.nvim_buf_get_option(0, "modified") then
        -- problem with this is any other BufWrite[Pre|Post]
        -- can really slow this system
        -- vim.cmd("doautocmd BufWritePre")
        -- vim.cmd(":write")
        vim.cmd(":update")
        -- vim.cmd("doautocmd BufWritePost")
      end
    end
  end
end

function M.setup()
  vim.g.enable_auto_update = true
  vim.cmd [[
  command!  -nargs=0 ToggleAutoUpdate lua require('util.auto_update').toggle_auto_update()
  augroup auto_update
  autocmd!
  autocmd InsertLeave,TextChanged * lua require('util.auto_update').update_buffer()
  augroup END
  ]]
end

return M
