local nvim_lsp = require('lspconfig')
local util = require('lspconfig/util')

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- binds omnifunc copleteion to omni complete
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rw', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  elseif client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  end

  -- TODO not sure I like this feature
  ---- Set autocommands conditional on server_capabilities
  --if client.resolved_capabilities.document_highlight then
  --  require('lspconfig').util.nvim_multiline_command [[
  --    :hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
  --    :hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
  --    :hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
  --    augroup lsp_document_highlight
  --      autocmd!
  --      autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
  --      autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
  --    augroup END
  --  ]]
  --end
end

  require'lspconfig'.tsserver.setup{}
  
  ---- NOTE: an efm config file prevents arror in log, only needs first line of: version:2
  --local eslint = {
  --  lintCommand = "./node_modules/.bin/eslint -f unix --stdin --stdin-filename ${INPUT}",
  --  lintIgnoreExitCode = true,
  --  lintStdin = true
  --}
  --
  --require "lspconfig".efm.setup {
  --  --cmd = {"efm-langserver", "-q"}, -- the `-q` prevents the  readng std in, printing stdout message
  --  init_options = {documentFormatting = true},
  --  filetypes = {"javascript", "typescript"},
  --  root_dir = function(fname)
  --    return util.root_pattern("tsconfig.json")(fname) or
  --    util.root_pattern(".eslintrc.js", ".git")(fname);
  --  end,
  --  init_options = {documentFormatting = true},
  --  settings = {
  --    rootMarkers = {".eslintrc.js", ".git/"},
  --    --logFile = "/home/alextylor/efm.log",
  --    --logLevel =  1,
  --    languages = {
  --      typescript = {eslint}
  --    }
  --  }
  --}

require'lspconfig'.diagnosticls.setup{
filetypes = {"javascript", "typescript"},
root_dir = function(fname)
  return util.root_pattern("tsconfig.json")(fname) or
  util.root_pattern(".eslintrc.js", ".git")(fname);
end,
init_options = {
  linters = {
    eslint = {
      command = "./node_modules/.bin/eslint",
      rootPatterns = {".eslintrc.js", ".git"},
      debounce = 100,
      args = {
        "--stdin",
        "--stdin-filename",
        "%filepath",
        "--format",
        "json"
      },
      sourceName = "eslint",
      parseJson = {
        errorsRoot = "[0].messages",
        line = "line",
        column = "column",
        endLine = "endLine",
        endColumn = "endColumn",
        message = "[eslint] ${message} [${ruleId}]",
        security = "severity"
      },
      securities = {
        [2] = "error",
        [1] = "warning"
      }
    },
  },
  filetypes = {
    javascript = "eslint",
    typescript = "eslint"
  }
}
}

-- Use a loop to conveniently both setup defined servers
-- and map buffer local keybindings when the language server attaches
local servers = { "tsserver" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup { on_attach = on_attach }
end
