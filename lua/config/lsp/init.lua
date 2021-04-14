local util = require('lspconfig/util')
local create_mappings = require("util.config").create_mappings

local function set_mappings(client, bufnr)
  local mappings = {
    n = {
      ['gD'] = '<Cmd>lua vim.lsp.buf.declaration()<CR>',
      ['gd'] = '<Cmd>lua vim.lsp.buf.definition()<CR>',
      ['K'] = '<Cmd>lua vim.lsp.buf.hover()<CR>',
      ['ca'] = '<Cmd>Telescope lsp_code_actions<CR>',
      ['cf'] = '<Cmd>lua require("config.lsp.funcs").fix_first_code_action()<CR>',
      ['gi'] = '<cmd>lua vim.lsp.buf.implementation()<CR>',
      ['<space>gs'] = '<cmd>Telescope lsp_document_symbols<CR>',
      ['gK'] = '<cmd>lua vim.lsp.buf.signature_help()<CR>',
      ['<space>wa'] = '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>',
      ['<space>wr'] = '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>',
      ['<space>wl'] = '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>',
      ['<space>D'] = '<cmd>lua vim.lsp.buf.type_definition()<CR>',
      ['<space>rn'] = '<cmd>lua vim.lsp.buf.rename()<CR>',
      ['gr'] = '<Cmd>Telescope lsp_references<CR>',
      ['<space>e'] = '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>',
      ['[d'] = '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>',
      [']d'] = '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>',
      ['<space>cl'] = '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>',
      ['<space>th'] = '<cmd>lua require("config.lsp.funcs").diagnostic_toggle_virtual_text()<CR>',
    }
  }

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting or
    client.resolved_capabilities.document_range_formatting then
    mappings.n["<space>fd"] = "<cmd>lua require('config.lsp.funcs').efm_priority_document_format()<CR>"
  end

  create_mappings(mappings)
end

-- TODO can get rid of this as using compe
-- TODO add check so if nvim_compe is not loaded then load this
local function set_omnifunc(bufnr)
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
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

vim.lsp.handlers["textDocument/publishDiagnostics"] =
vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  underline = true,
  signs = true,
  update_in_insert = false,
  virtual_text = false
})

local function onAttach(client, bufnr)
    require('config.lsp.highlights')
    -- set_omnifunc(bufnr)
    set_mappings(client, bufnr)
    set_highlights(client)
  end

-- GO111MODULE=on go get golang.org/x/tools/gopls@latest
require'lspconfig'.gopls.setup{on_attach = onAttach}

require'lspconfig'.tsserver.setup{on_attach = onAttach}

-- require'lspconfig'.terraformls.setup{
--   on_attach = on_attach,
--   filetypes = {"tf", "terraform"}
-- }

local eslint = {
  lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
  lintStdin = true,
  lintFormats = {"%f:%l:%c: %m"},
  lintIgnoreExitCode = true,
  formatCommand = "eslint_d --fix-to-stdout --stdin --stdin-filename=${INPUT}",
  formatStdin = true
}

require "lspconfig".efm.setup {
  init_options = {documentFormatting = true},
  filetypes = {"javascript", "typescript"},
  root_dir = function(fname)
    return util.root_pattern("tsconfig.json")(fname) or
    util.root_pattern(".eslintrc.js", ".git")(fname);
  end,
  settings = {
    rootMarkers = {".eslintrc.js", ".git/"},
    languages = {
      javascript = {eslint},
      typescript = {eslint}
    }
  }
}
