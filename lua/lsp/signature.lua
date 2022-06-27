-- not using this atm, as ther eare a few edge cases that are a little
-- annoying to handle
local M = {}

-- auto popup signature help... cheap but could do with better pum support
-- i.e. close sgnature help when pum visible
local function cheap_signiture()
  if vim.fn.mode() ~= "i" then
    return
  end

  if vim.fn.pumvisible() == 0 then
    local clients = vim.lsp.buf_get_clients(0)
    for _, client in pairs(clients) do
      if client.server_capabilities.signature_help then
        vim.lsp.buf.signature_help()
        return
      end
    end
  end
end

local function cheap_signiture_toggle()
  local toggle = vim.g.cheap_signiture_enabled
  toggle = not toggle
  if toggle then
    vim.api.nvim_create_autocmd("CursorMovedI", {
      pattern = "*",
      callback = function()
        cheap_signiture()
      end,
      group = vim.api.nvim_create_augroup("lsp_hover", { clear = true }),
    })
  else
    vim.api.nvim_del_augroup_by_name("lsp_hover")
  end
  vim.g.cheap_signiture_enabled = toggle
end

function M.setup()
  vim.api.nvim_create_user_command("ToggleSignature", cheap_signiture_toggle, { force = true })
  vim.g.cheap_signiture_enabled = false
  cheap_signiture_toggle()
end

return M
