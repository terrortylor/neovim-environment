
local M = {}

local function set_mappings(client)
  local set = vim.keymap.set

  -- TODO have a func to prefix vsplit/splt/tabnew wrapper
  set("n", "gd", require("telescope.builtin").lsp_definitions, {buffer=true})

  set("n", "gsd", function()
    vim.cmd "vsplit"
    require("telescope.builtin").lsp_definitions()
  end, {buffer=true})

  set("n", "ghd", function()
    vim.cmd "split"
    require("telescope.builtin").lsp_definitions()
  end, {buffer=true})

  set("n", "gD", vim.lsp.buf.declaration, {buffer=true})
  set("n", "gsD", "<Cmd>vsplit <BAR> lua vim.lsp.buf.declaration()<CR>", {buffer=true})
  set("n", "ghD", "<Cmd>split <BAR> lua vim.lsp.buf.declaration()<CR>", {buffer=true})
  -- TODO save and restore mark?
  set("n", "gtD", "mt<Cmd>tabnew % <CR> `t <Cmd> lua vim.lsp.buf.declaration()<CR>", {buffer=true})
  set("n", "K", vim.lsp.buf.hover, {buffer=true})
  -- luacheck: ignore
  set("n","<leader>cf",'<Cmd>lua vim.diagnostic.goto_next()<CR><Cmd>lua require("lsp.codeactions").fix_first_code_action()<CR>', {buffer=true})
  -- luacheck: ignore
  set("n", "<leader>cF", '<Cmd>lua vim.diagnostic.goto_prev()<CR><Cmd>lua require("lsp.codeactions").fix_first_code_action()<CR>', {buffer=true})
  set("n", "gI", "<cmd>Telescope lsp_implementations<CR>", {buffer=true})
  set("n", "<space>gss", "<cmd>Telescope lsp_document_symbols<CR>", {buffer=true})
  set("n", "gk", vim.lsp.buf.signature_help, {buffer=true})
  set("n", "<space>D", vim.lsp.buf.type_definition, {buffer=true})
  set("n", "<space>vD", "<cmd>vsplit <BAR> lua vim.lsp.buf.type_definition()<CR>", {buffer=true})
  set("n", "<space>hD", "<cmd>split <BAR> lua vim.lsp.buf.type_definition()<CR>", {buffer=true})
  set("n", "<space>rn", require("scratch.lsp_rename_popup").rename, {buffer=true})
  set("n", "gr", "<Cmd>Telescope lsp_references<CR>", {buffer=true})
  set("n", "<space>e", vim.diagnostic.open_float, {buffer=true})
  set("n", "<space>ge", "<cmd>Telescope diagnostics<CR>", {buffer=true})
  set("n", "[d", vim.diagnostic.goto_prev, {buffer=true})
  set("n", "]d", vim.diagnostic.goto_next, {buffer=true})
  set("n", "<space>th",require("lsp.diagnostics").diagnostic_toggle_virtual_text, {buffer=true})
  set({"n","x"}, "<leader>ca", vim.lsp.buf.range_code_action, {buffer=true})

  -- Set some keybinds conditional on server capabilities
  if client.server_capabilities.document_formatting or client.resolved_capabilities.document_range_formatting then
    -- TODO this is fucking gross, but quickfix
    -- Tried to do filetype mapping but isn't picked up for some reason when vim starts, only when explicitly settings
    -- the filetype to go in the command line... user that is a bug though
    if vim.bo.filetype == "go" then
      set("n", "<space>fd","<cmd>wall<cr><cmd>GoImport<CR>", {buffer=true})
    else
  -- luacheck: ignore
     set("n", "<space>fd","<cmd>wall<cr><cmd>lua require('lsp.format').efm_priority_document_format()<CR>", {buffer=true})
    end
  end
end

-- only sets omnifunc if cmp not loaded
local function set_omnifunc(bufnr)
  if not vim.g.loaded_cmp then
    print("Setting built in LSP omnifunc")
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
  end
end

local function set_highlights(client)
  -- TODO not sure I like this feature, unless updatetime is set to like 500~
  -- have to check other CursorHold autocommands
  -- Set autocommands conditional on server_capabilities
  if client.server_capabilities.document_highlight then
    vim.api.nvim_exec(
      [[
      augroup lsp_document_highlight
        autocmd!
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]],
      false
    )
  end
end

-- snippet support
function M.buildCapabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  -- be nice to have this wrapped but the plugin isn't loaded at this point...
  capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)
  return capabilities
end

function M.on_attach(client, bufnr)
  require("plugins.lsp.lsp_signature").attach(bufnr)
  require("plugins.lsp.lightbulb")

  set_omnifunc(bufnr)
  set_mappings(client)
  set_highlights(client)

  -- add border
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "double" })
  -- luacheck: ignore
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
    vim.lsp.handlers.signature_help,
    { border = "double", focusable = false }
  )

  -- format publsh diagnostics
  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    signs = true,
    update_in_insert = false,
    virtual_text = false,
  })
end

return M
