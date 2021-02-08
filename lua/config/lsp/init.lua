local nvim_lsp = require('lspconfig')
local util = require('lspconfig/util')

vim.b.show_virtual_text = false

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
  buf_set_keymap('n', 'ca', '<Cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', 'gk', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
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
    buf_set_keymap("n", "<space>fd", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  elseif client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("n", "<space>fd", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  end

  -- TODO not sure I like this feature, unless updatetime is set to like 500~
  -- have to check other CursorHold autocommands
  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    require('lspconfig').util.nvim_multiline_command [[
      :hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
      :hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
      :hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
      augroup lsp_document_highlight
        autocmd!
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]]
  end
end

-- TODO would like virtual text and loclist to be configurable with func...
-- see help vim.lsp.diagnostic.on_publish_diagnostics()
    vim.lsp.handlers["textDocument/publishDiagnostics"] = function(...)
    vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics,
        {
          virtual_text = function(bufnr, client_id)
            return vim.b.show_virtual_text
          end,
        }
    )(...)
    pcall(vim.lsp.diagnostic.set_loclist, {open_loclist = false})
    end

  --vim.lsp.handlers["textDocument/formatting"] = function(err, _, result, _, bufnr)
  --print("her")
  --if err ~= nil or result == nil then
  --  print("here2")
  --    return
  --end
  --if not vim.api.nvim_buf_get_option(bufnr, "modified") then
  --  print("here3")
  --  print(results)
  --        vim.api.nvim_command("checktime")
  --    --local view = vim.fn.winsaveview()
  --    --vim.lsp.util.apply_text_edits(result, bufnr)
  --    --vim.fn.winrestview(view)
  --    --if bufnr == vim.api.nvim_get_current_buf() then
  --    --  print("here4")
  --    --    vim.api.nvim_command("noautocmd :update")
  --    --end
  --end
  --end

require'lspconfig'.tsserver.setup{
  on_attach = on_attach
}

require'lspconfig'.terraformls.setup{
  on_attach = on_attach,
  filetypes = {"tf", "terraform"}
}

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
    formatters = {
      eslintfmt = {
        command = "./node_modules/.bin/eslint",
        --args = {"--stdin", "--stdin-filename", "%filepath", "--fix"},
        --args = {"--stdin", "--fix"},
        --isStdout = false,
        -- this works inthe back ground...
        doesWriteToFile = true,
        args = {"%filepath", "--fix"},
        -- TODO test this requiredFiles
        --requiredFiles = {".eslintrc.js"},
        rootPatterns = {
          ".prettierrc",
          ".prettierrc.json",
          ".prettierrc.toml",
          ".prettierrc.json",
          ".prettierrc.yml",
          ".prettierrc.yaml",
          ".prettierrc.json5",
          ".prettierrc.js",
          ".prettierrc.cjs",
          "prettier.config.js",
          "prettier.config.cjs", ".git"
        }
      },
      --prettier = {
      --  command = "./node_modules/.bin/prettier",
      --  --args = {"--stdin-filename", "%filepath"},
      --  args = {"--stdin", "--stdin-filename", "%filepath"},
      --  rootPatterns = {
      --    ".prettierrc",
      --    ".prettierrc.json",
      --    ".prettierrc.toml",
      --    ".prettierrc.json",
      --    ".prettierrc.yml",
      --    ".prettierrc.yaml",
      --    ".prettierrc.json5",
      --    ".prettierrc.js",
      --    ".prettierrc.cjs",
      --    "prettier.config.js",
      --    "prettier.config.cjs", ".git"
      --  }
      --}
    },
    filetypes = {
      javascript = "eslint",
      typescript = "eslint"
    },
    formatFiletypes = {
      typescript = "eslintfmt"
    }
  }
}
