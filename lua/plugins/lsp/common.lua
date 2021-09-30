local util = require('lspconfig/util')
local create_mappings = require("util.config").create_mappings

local M = {}

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
      ['<leader>ca'] = '<Cmd>lua require("plugins.telescope").dropdown_code_actions()<CR>',
      ['<leader>cf'] = '<Cmd>lua vim.lsp.diagnostic.goto_next()<CR><Cmd>lua require("lsp.codeactions").fix_first_code_action()<CR>',
      ['<leader>cF'] = '<Cmd>lua vim.lsp.diagnostic.goto_prev()<CR><Cmd>lua require("lsp.codeactions").fix_first_code_action()<CR>',
      -- ['gI'] = '<cmd>Telescope lsp_implementations<CR>',
      ['gI'] = '<cmd>lua require("plugins.lsp.common").handler_implementation()<CR>',
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
      ['<space>th'] = '<cmd>lua require("lsp.diagnostics").diagnostic_toggle_virtual_text()<CR>',
    },
    i = {
      ['<c-k>'] = '<cmd>lua vim.lsp.buf.signature_help()<CR>',
    }
  }

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting or
    client.resolved_capabilities.document_range_formatting then
    -- TODO this is fucking gross, but quickfix 
    -- Tried to do filetype mapping but isn't picked up for some reason when vim starts, only when explicitly settings
    -- the filetype to go in the command line... user that is a bug though
    if vim.bo.filetype == "go" then
      mappings.n["<space>fd"] = "<cmd>GoImport<CR>"
    else
      mappings.n["<space>fd"] = "<cmd>lua require('lsp.format').efm_priority_document_format()<CR>"
    end
  end

  create_mappings(mappings, nil, bufnr)
end

-- only sets omnifunc if cmp not loaded
local function set_omnifunc(bufnr)
  if not vim.g.loaded_cmp then
    print("Setting built in LSP omnifunc")
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
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
function M.buildCapabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  -- be nice to have this wrapped but the plugin isn't loaded at this point...
  capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
  return capabilities
end

function M.on_attach(client, bufnr)
  require('lsp.signature').setup()

  set_omnifunc(bufnr)
  set_mappings(client, bufnr)
  set_highlights(client)

  -- add border
  vim.lsp.handlers["textDocument/hover"] =  vim.lsp.with(vim.lsp.handlers.hover, {border = "double"})
  vim.lsp.handlers["textDocument/signatureHelp"] =  vim.lsp.with(vim.lsp.handlers.signature_help, {border = "double", focusable = false})

  -- format publsh diagnostics
  vim.lsp.handlers["textDocument/publishDiagnostics"] =
  vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    signs = true,
    update_in_insert = false,
    virtual_text = false
  })
end

local ns_rename = vim.api.nvim_create_namespace "tj_rename"

function MyLspRename()
  local bufnr = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_clear_namespace(bufnr, ns_rename, 0, -1)

  local current_word = vim.fn.expand "<cword>"

  local plenary_window = require("plenary.window.float").percentage_range_window(0.5, 0.2)
  vim.api.nvim_buf_set_option(plenary_window.bufnr, "buftype", "prompt")
  vim.fn.prompt_setprompt(plenary_window.bufnr, string.format('Rename "%s" to > ', current_word))
  vim.fn.prompt_setcallback(plenary_window.bufnr, function(text)
    vim.api.nvim_win_close(plenary_window.win_id, true)

    if text ~= "" then
      vim.schedule(function()
        vim.api.nvim_buf_delete(plenary_window.bufnr, { force = true })

        vim.lsp.buf.rename(text)
      end)
    else
      print "Nothing to rename!"
    end
  end)

  vim.cmd [[startinsert]]
end


GoImports = function(timeoutms)
  local context = { source = { organizeImports = true } }
  vim.validate { context = { context, "t", true } }
  local params = vim.lsp.util.make_range_params()
  params.context = context
  local method = "textDocument/codeAction"
  local resp = vim.lsp.buf_request_sync(0, method, params, timeoutms)
  if resp and resp[1] then
    local result = resp[1].result
    if result and result[1] then
      local edit = result[1].edit
      vim.lsp.util.apply_workspace_edit(edit)
    end
  end
  vim.lsp.buf.formatting_sync()
end

function M.handler_implementation()
  local params = vim.lsp.util.make_position_params()

  vim.lsp.buf_request(0, "textDocument/implementation", params, function(err, method, result, client_id, bufnr, config)
    local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")

    -- In go code, I do not like to see any mocks for impls
    if ft == "go" then
      local new_result = vim.tbl_filter(function(v)
        return not string.find(v.uri, "_mock")
      end, result)

      if #new_result > 0 then
        result = new_result
      end
    end

    vim.lsp.handlers["textDocument/implementation"](err, method, result, client_id, bufnr, config)
    vim.cmd [[normal! zz]]
  end)
end

return M
