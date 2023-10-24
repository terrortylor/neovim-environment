local filesystem = require("util.filesystem")
local ignore_filetype = require("util.buffer").ignore_filetype
local log = require("util.log")

local M = {}

M.debounce = 500

function M.toggle_auto_update()
  vim.g.enable_auto_update = not vim.g.enable_auto_update
  if vim.g.enable_auto_update then
    vim.opt.shortmess:append({ F = true })
  else
    vim.opt.shortmess:append({ F = false })
  end
  -- TODO this should be a post hook
  vim.cmd("redrawtabline")
end

local queued_event = false
local debounce_running = false

local function debounce(lfn, duration)
  if debounce_running then
    queued_event = true
  else
    debounce_running = true
    queued_event = false
    vim.defer_fn(function()
      debounce_running = false
      if queued_event then
        queued_event = false
        debounce(lfn, M.debounce)
      else
        lfn()
      end
    end, duration)
  end
end

--- Saves a buffer if the file path exists (directory path), if the file
-- exists all ready then updates, if the file has no name then do nothing
function M.update_buffer()
  if vim.g.enable_auto_update then
    local filename = vim.fn.expand("%")
    if filename ~= "" then
      if ignore_filetype() then
        return
      end

      local path = vim.fn.expand("%:p:h")
      if path:match("term://") then
        log.info("Terminal buffer, not saving")
        return
      elseif path:match("neorg://") then
        log.info("Neorg buffer, not saving")
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

      -- check if modified then run aucommand?
      if vim.api.nvim_buf_get_option(0, "modified") then
        -- problem with this is any other BufWrite[Pre|Post]
        -- can really slow this system
        -- vim.cmd("doautocmd BufWritePre")
        -- vim.cmd(":write")
        -- TODO add option to write all buffers?
        vim.cmd(":update!")
        -- vim.cmd("doautocmd BufWritePost")
      end
    end
  end
end

function M.write_buffers()
  debounce(M.update_buffer, M.debounce)
end

function M.setup()
  vim.g.enable_auto_update = true
  -- in theory this should hide the written message but doesn't seem to work
  -- could use combination of silent  and unsilent, but seems clunky
  vim.opt.shortmess:append({ F = true })
  vim.api.nvim_create_user_command("ToggleAutoUpdate", require("util.auto_update").toggle_auto_update, { force = true })
  vim.cmd([[
  augroup auto_update
  autocmd!
  autocmd InsertLeave,TextChanged * noautocmd lua require('util.auto_update').write_buffers()
  augroup END
  ]])
end

return M
