local M = {}

local levels = {
  errors = 'Error',
  warnings = 'Warning',
  -- Currently only displaying Errors and Warning in tabline
  -- info = 'Information',
  -- hints = 'Hint'
}

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

local all_diagnostics_to_qf = function() -- luacheck: ignore
  local diagnostics = vim.lsp.diagnostic.get_all()
  local qflist = {}
  for bufnr, diagnostic in pairs(diagnostics) do
    for _, d in ipairs(diagnostic) do
      --  1 = Error, 2 = Warning, 3 = Information, 4 = Hint
      if d.severity == 1 then
        d.bufnr = bufnr
        d.lnum = d.range.start.line + 1
        d.col = d.range.start.character + 1
        d.text = d.message
        table.insert(qflist, d)
      end
    end
  end
  return qflist
end



-- -- Modified from: https://github.com/neovim/nvim-lspconfig/issues/69
-- local method = "textDocument/publishDiagnostics"
-- local last_quickfix = {}
-- local default_handler = vim.lsp.handlers[method]
-- vim.lsp.handlers[method] = function(err, method, result, client_id, bufnr, config)
--   default_handler(err, method, result, client_id, bufnr, config)
--   -- TODO have method to disable/toggle this behaviour
--   local qflist = all_diagnostics_to_qf()
--   if #last_quickfix ~= #qflist or not vim.deep_equal(last_quickfix, qflist) then
--     last_quickfix = qflist
--     vim.lsp.util.set_qflist(qflist)
--   end
-- end

-- TODO what to do here? is the handler override above too heavy handed?
-- function M.set_quickfixlist_all_diagnoistics()
--   local qflist = all_diagnostics_to_qf()
--   vim.lsp.util.set_qflist(qflist)
-- end

-- Limits a single diagnostic sign per line, showing the worst for that line
-- TODO fix, this was workig but now seems to do a sign column per client
function M.limit_diagnostic_sign_column()
  local orig_set_signs = vim.lsp.diagnostic.set_signs

  local set_signs_limited = function(diagnostics, bufnr, client_id, sign_ns, opts)
    print("in here", client_id, sign_ns)
    opts = opts or {}
    -- opts.priority = 1

--     if not diagnostics then
--       diagnostics = diagnostic_cache[bufnr][client_id]
--     end

    if not diagnostics then
      return
    end

    print("has diagnostics")
    print(vim.inspect(diagnostics[1]))
    -- Work out max severity diagnostic per line
    local max_diagnostics = {}
    local check_severity = function(d)
      print("d", d.range.start.line, d.severity)
      if max_diagnostics[d.range.start.line] then
        local current_d = max_diagnostics[d.range.start.line]
        if d.severity < current_d.severity then
          print("found severity")
          max_diagnostics[d.range.start.line] = d
        end
      else
        max_diagnostics[d.range.start.line] = d
      end
    end
    vim.tbl_map(check_severity, diagnostics)

    -- call original function
    orig_set_signs(vim.tbl_values(max_diagnostics), bufnr, client_id, sign_ns, opts)
  end

  vim.lsp.diagnostic.set_signs = set_signs_limited
end

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

-- Called from mapping to toggle virtual text on and off for a given buffer
-- https://www.reddit.com/r/neovim/comments/m7ne92/how_to_redraw_lsp_diagnostics/
-- TODO this may be better to be global
function M.diagnostic_toggle_virtual_text()
  local virtual_text = vim.b.lsp_virtual_text_enabled
  virtual_text = not virtual_text
  vim.b.lsp_virtual_text_enabled = virtual_text
  vim.lsp.diagnostic.display(vim.lsp.diagnostic.get(0, 1), 0, 1, {virtual_text = virtual_text})
end

-- TODO could update toggle swithc betwen showing or show only if Hovered
-- autocmd CursorHold <buffer> lua vim.lsp.diagnostic.show_line_diagnostics()
-- shows diagnostic on line

return M
