local M = {}

local function is_empty(tbl)
  for _,_ in pairs(tbl) do return false end
  return true
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
    --print(diag)
  end
end

function M.diagnostic_toggle_virtual_text()
 vim.b.show_virtual_text = not vim.b.show_virtual_text
 vim.cmd("normal! i\\<esc>")
 --vim.cmd("redraw")
end

return M
