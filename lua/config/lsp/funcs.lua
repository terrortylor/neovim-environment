local M = {}

local function is_empty(tbl)
  for _,_ in pairs(tbl) do return false end -- luacheck: ignore
  return true
end

local efm_priority_document_format
function M.efm_priority_document_format()
  if not efm_priority_document_format then
    local clients = vim.lsp.buf_get_clients(0)
    if #clients > 1 then
      -- check if multiple clients, and if efm is setup
      for _,c1 in pairs(clients) do
        if c1.name == "efm" then
          -- if efm then disable others
          for _,c2 in pairs(clients) do
            -- print(c2.name, c2.resolved_capabilities.document_formatting)
            if c2.name ~= "efm" then c2.resolved_capabilities.document_formatting = false end
          end
          -- no need to contunue first loop
          break
        end
      end
    end
  end
  -- no need to do above check again
  efm_priority_document_format = true
  -- format the doc
  -- TODO need a check to make sure actually has this func on one of the availble clients
  vim.lsp.buf.formatting()
end

function M.get_line_diagnostics()
  local tbl = {}
  local line_nr = vim.api.nvim_win_get_cursor(0)[1] - 1
  local buf_nr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.buf_get_clients(0)

  for _,client in pairs(clients) do
    local id = client.id
    local name = client.name
    local diag = vim.lsp.diagnostic.get_line_diagnostics(buf_nr, line_nr, {}, id)
    if not is_empty(diag) then
      table.insert(tbl, "Source: " .. name)
      table.insert(tbl, "Message:")
      table.insert(tbl, diag[1].message)
    end
  end
  return tbl
end

-- This is just testing, it's basically a a shit verson of vim.lsp.diagnostic.show_line_diagnostics()
function M.show_line_diagnostics()
  local diag_msgs = M.get_line_diagnostics()
  print(vim.inspect(diag_msgs))

  -- Just show's the last line which is what is displayed anyhow, as last message takes precedence
  local diag = diag_msgs[#diag_msgs]
  if diag then
    print(diag)
  end
end

-- Called from mappig to toggle virtual text on and off for a given buffer
-- https://www.reddit.com/r/neovim/comments/m7ne92/how_to_redraw_lsp_diagnostics/
function M.diagnostic_toggle_virtual_text()
  local virtual_text = vim.b.lsp_virtual_text_enabled
  virtual_text = not virtual_text
  vim.b.lsp_virtual_text_enabled = virtual_text
  vim.lsp.diagnostic.display(vim.lsp.diagnostic.get(0, 1), 0, 1, {virtual_text = virtual_text})
end

return M
