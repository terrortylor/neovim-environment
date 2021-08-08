local util = require('lspconfig/util')
local create_mappings = require("util.config").create_mappings

local M = {}

local border = {
      {"🭽", "FloatBorder"},
      {"▔", "FloatBorder"},
      {"🭾", "FloatBorder"},
      {"▕", "FloatBorder"},
      {"🭿", "FloatBorder"},
      {"▁", "FloatBorder"},
      {"🭼", "FloatBorder"},
      {"▏", "FloatBorder"},
}

local function set_mappings(client, bufnr)
  local mappings = {
    n = {
      -- TODO have a func to prefix vsplit/splt/tabnew wrapper
      ['gD'] = '<Cmd>Telescope lsp_definitions<CR>',
      ['gsD'] = '<Cmd>vsplit <BAR> Telescope lsp_definitions<CR>', -- overkill but i like these mappings
      ['ghD'] = '<Cmd>split <BAR> Telescope lsp_definitions<CR>', -- overkill but i like these mappings
      ['gd'] = '<Cmd>lua vim.lsp.buf.definition()<CR>',
      ['gsd'] = '<Cmd>vsplit <BAR> lua vim.lsp.buf.definition()<CR>',
      ['ghd'] = '<Cmd>split <BAR> lua vim.lsp.buf.definition()<CR>',
    -- TODO save and restore mark?
      ['gtd'] = 'mt<Cmd>tabnew % <CR> `t <Cmd> lua vim.lsp.buf.definition()<CR>',
      ['K'] = '<Cmd>lua vim.lsp.buf.hover()<CR>',
      ['ca'] = '<Cmd>lua require("plugins.telescope").dropdown_code_actions()<CR>',
      ['cf'] = '<Cmd>lua require("util.lsp").fix_first_code_action()<CR>',
      ['gI'] = '<cmd>Telescope lsp_implementations<CR>',
      -- ['gsI'] = '<cmd>vsplit <BAR> lua vim.lsp.buf.implementation()<CR>',
      -- ['ghI'] = '<cmd>split <BAR> lua vim.lsp.buf.implementation()<CR>',
      ['<space>gs'] = '<cmd>Telescope lsp_document_symbols<CR>',
      ['gK'] = '<cmd>lua vim.lsp.buf.signature_help()<CR>',
      -- ['<space>wa'] = '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>',
      -- ['<space>wr'] = '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>',
      -- ['<space>wl'] = '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>',
      ['<space>D'] = '<cmd>lua vim.lsp.buf.type_definition()<CR>',
      ['<space>vD'] = '<cmd>vsplit <BAR> lua vim.lsp.buf.type_definition()<CR>',
      ['<space>hD'] = '<cmd>split <BAR> lua vim.lsp.buf.type_definition()<CR>',
      ['<space>rn'] = '<cmd>lua vim.lsp.buf.rename()<CR>',
      ['gr'] = '<Cmd>Telescope lsp_references<CR>',
      ['<space>e'] = '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>',
      ['<space>ge'] = '<cmd>Telescope lsp_workspace_diagnostics<CR>',
      ['[d'] = '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>',
      [']d'] = '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>',
      ['<space>th'] = '<cmd>lua require("util.lsp").diagnostic_toggle_virtual_text()<CR>',
    }
  }

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting or
    client.resolved_capabilities.document_range_formatting then
    mappings.n["<space>fd"] = "<cmd>lua require('util.lsp').efm_priority_document_format()<CR>"
  end

  create_mappings(mappings, nil, bufnr)
end

-- only sets omnifunc if compe not loaded
local function set_omnifunc(bufnr)
  if not vim.g.loaded_compe then
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
  end
end

local function set_highlights(client)
  -- TODO not sure I like this feature, unless updatetime is set to like 500~
  -- have to check other CursorHold autocommands
  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
      augroup lsp_document_highlight
        autocmd!
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end
end

-- snippet support
function M.compeSnippetCapabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
      'documentation',
      'detail',
      'additionalTextEdits',
    }
  }
  return capabilities
end


function M.on_attach(client, bufnr)
  set_omnifunc(bufnr)
  set_mappings(client, bufnr)
  set_highlights(client)

  -- add border
  vim.lsp.handlers["textDocument/hover"] =  vim.lsp.with(vim.lsp.handlers.hover, {border = border})
  vim.lsp.handlers["textDocument/signatureHelp"] =  vim.lsp.with(vim.lsp.handlers.hover, {border = border})

  -- format publsh diagnostics
  vim.lsp.handlers["textDocument/publishDiagnostics"] =
  vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    signs = true,
    update_in_insert = false,
    virtual_text = false
  })

  require "lsp_signature".on_attach()
end

return M