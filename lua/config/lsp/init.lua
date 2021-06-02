local util = require('lspconfig/util')
local create_mappings = require("util.config").create_mappings
-- local lsp_funcs = require("config.lsp.funcs")

local function set_mappings(client, bufnr)
  local mappings = {
    n = {
      -- TODO have a func to prefix vsplit/splt/tabnew wrapper
      ['gD'] = '<Cmd>lua vim.lsp.buf.declaration()<CR>',
      ['gsD'] = '<Cmd>vsplit <BAR> lua vim.lsp.buf.declaration()<CR>',
      ['ghD'] = '<Cmd>split <BAR> lua vim.lsp.buf.declaration()<CR>',
      ['gd'] = '<Cmd>lua vim.lsp.buf.definition()<CR>',
      ['gsd'] = '<Cmd>vsplit <BAR> lua vim.lsp.buf.definition()<CR>',
      ['ghd'] = '<Cmd>split <BAR> lua vim.lsp.buf.definition()<CR>',
    -- TODO save and restore mark?
      ['gtd'] = 'mt<Cmd>tabnew % <CR> `t <Cmd> lua vim.lsp.buf.definition()<CR>',
      ['K'] = '<Cmd>lua vim.lsp.buf.hover()<CR>',
      ['ca'] = '<Cmd>lua require("plugins.telescope").dropdown_code_actions()<CR>',
      ['cf'] = '<Cmd>lua require("config.lsp.funcs").fix_first_code_action()<CR>',
      ['gI'] = '<cmd>lua vim.lsp.buf.implementation()<CR>',
      ['gsI'] = '<cmd>vsplit <BAR> lua vim.lsp.buf.implementation()<CR>',
      ['ghI'] = '<cmd>split <BAR> lua vim.lsp.buf.implementation()<CR>',
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
      ['[d'] = '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>',
      [']d'] = '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>',
      ['<space>th'] = '<cmd>lua require("config.lsp.funcs").diagnostic_toggle_virtual_text()<CR>',
    }
  }

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting or
    client.resolved_capabilities.document_range_formatting then
    mappings.n["<space>fd"] = "<cmd>lua require('config.lsp.funcs').efm_priority_document_format()<CR>"
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

vim.lsp.handlers["textDocument/publishDiagnostics"] =
vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  underline = true,
  signs = true,
  update_in_insert = false,
  virtual_text = false
})
-- limit sign diagnostics to 1 per line
-- lsp_funcs.limit_diagnostic_sign_column()

local function onAttach(client, bufnr)
  require('config.lsp.highlights')
  set_omnifunc(bufnr)
  set_mappings(client, bufnr)
  set_highlights(client)
end

-- npm i -g bash-language-server
require'lspconfig'.bashls.setup{}

-- GO111MODULE=on go get golang.org/x/tools/gopls@latest
require'lspconfig'.gopls.setup{on_attach = onAttach}

require'lspconfig'.tsserver.setup{on_attach = onAttach}

-- require'lspconfig'.terraformls.setup{
--   on_attach = on_attach,
--   filetypes = {"tf", "terraform"}
-- }

-- eslint via efm
local eslint = {
  lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
  lintStdin = true,
  lintFormats = {"%f:%l:%c: %m"},
  lintIgnoreExitCode = true,
  formatCommand = "eslint_d --fix-to-stdout --stdin --stdin-filename=${INPUT}",
  formatStdin = true
}

require "lspconfig".efm.setup {
  -- cmd = {"efm-langserver", "-logfile", "/home/alextylor/efm.log"},
  init_options = {documentFormatting = true},
  filetypes = {"javascript", "typescript", "javascriptreact", "typescriptreact"},
  root_dir = function(fname)
    return util.root_pattern("tsconfig.json")(fname) or
    util.root_pattern(".eslintrc.js")(fname);
    -- util.root_pattern(".eslintrc.js", ".git")(fname);
  end,
  settings = {
    rootMarkers = {".eslintrc.js", ".git/"},
    languages = {
      javascript = {eslint},
      typescript = {eslint},
      javascriptreact = {eslint},
      typescriptreact = {eslint},
    }
  }
}

-- sumneko
local system_name
if vim.fn.has("mac") == 1 then
  system_name = "macOS"
elseif vim.fn.has("unix") == 1 then
  system_name = "Linux"
elseif vim.fn.has('win32') == 1 then
  system_name = "Windows"
else
  print("Unsupported system for sumneko")
end

-- set the path to the sumneko installation; if you previously installed via the now deprecated :LspInstall, use
local sumneko_root_path = vim.fn.stdpath('cache')..'/lua-language-server'
local sumneko_binary = sumneko_root_path.."/bin/"..system_name.."/lua-language-server"

require'lspconfig'.sumneko_lua.setup {
  on_attach = onAttach,
  cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"};
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = vim.split(package.path, ';'),
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim', 'describe', 'before_each', 'after_each', 'it'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = {
          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
        },
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}
