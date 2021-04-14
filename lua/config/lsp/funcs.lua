local M = {}

local levels = {
  errors = 'Error',
  warnings = 'Warning',
  info = 'Information',
  hints = 'Hint'
}

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

-- Lifted from:
-- https://github.com/jose-elias-alvarez/nvim-lsp-ts-utils/blob/main/lua/nvim-lsp-ts-utils.lua
function M.fix_first_code_action()
  local params = vim.lsp.util.make_range_params()
  params.context = {
    diagnostics = vim.lsp.diagnostic.get_line_diagnostics()
  }

  vim.lsp.buf_request(0, "textDocument/codeAction", params,
  function(_, _, responses)
    if not responses or not responses[1] then
      print("No code actions available")
      return
    end

    vim.lsp.buf.execute_command(responses[1])
  end)
end

-- -- https://www.reddit.com/r/neovim/comments/iil3jt/nvimlsp_how_to_display_all_diagnostics_for_entire/
-- -- populate quickfix list with diagnostics
-- local method = "textDocument/publishDiagnostics"
-- local default_callback = vim.lsp.handlers[method]
-- 
-- vim.lsp.handlers[method] = function(err, method, result, client_id)
--   default_callback(err, method, result, client_id)
--   if result and result.diagnostics then
--     local item_list = {}
--     for _, v in ipairs(result.diagnostics) do
--       local fname = result.uri
--       table.insert(item_list, { filename = fname, lnum = v.range.start.line + 1, col = v.range.start.character + 1; text = v.message; })
--     end
--     local old_items = vim.fn.getqflist()
--     for _, old_item in ipairs(old_items) do
--       local bufnr = vim.uri_to_bufnr(result.uri)
--       if vim.uri_from_bufnr(old_item.bufnr) ~= result.uri then
--         table.insert(item_list, old_item)
--       end
--     end
--     vim.fn.setqflist({}, ' ', { title = 'LSP'; items = item_list; })
--   end
-- end
-- 

function M.get_buf_diagnostic_count(bufnr)
  local result = {}

  for k, level in pairs(levels) do
    result[k] = vim.lsp.diagnostic.get_count(bufnr, level)
  end

  return result
end

function M.get_all_diagnostic_count()
  local result = {}

  local buffers = vim.api.nvim_list_bufs()
  for _,b in pairs(buffers) do
    if vim.api.nvim_buf_is_loaded(b) then
      for k, level in pairs(levels) do
        local count = result[k] or 0
        result[k] = count + vim.lsp.diagnostic.get_count(b, level)
      end
    end
  end

  return result
end

-- function M.get_line_diagnostics()
--   local tbl = {}
--   local line_nr = vim.api.nvim_win_get_cursor(0)[1] - 1
--   local buf_nr = vim.api.nvim_get_current_buf()
--   local clients = vim.lsp.buf_get_clients(0)
-- 
--   for _,client in pairs(clients) do
--     local id = client.id
--     local name = client.name
--     local diag = vim.lsp.diagnostic.get_line_diagnostics(buf_nr, line_nr, {}, id)
--     if not is_empty(diag) then
--       table.insert(tbl, "Source: " .. name)
--       table.insert(tbl, "Message:")
--       table.insert(tbl, diag[1].message)
--     end
--   end
--   return tbl
-- end
-- 
-- -- This is just testing, it's basically a a shit verson of vim.lsp.diagnostic.show_line_diagnostics()
-- function M.show_line_diagnostics()
--   local diag_msgs = M.get_line_diagnostics()
--   print(vim.inspect(diag_msgs))
-- 
--   -- Just show's the last line which is what is displayed anyhow, as last message takes precedence
--   local diag = diag_msgs[#diag_msgs]
--   if diag then
--     print(diag)
--   end
-- end

-- Called from mappig to toggle virtual text on and off for a given buffer
-- https://www.reddit.com/r/neovim/comments/m7ne92/how_to_redraw_lsp_diagnostics/
function M.diagnostic_toggle_virtual_text()
  local virtual_text = vim.b.lsp_virtual_text_enabled
  virtual_text = not virtual_text
  vim.b.lsp_virtual_text_enabled = virtual_text
  vim.lsp.diagnostic.display(vim.lsp.diagnostic.get(0, 1), 0, 1, {virtual_text = virtual_text})
end

return M
