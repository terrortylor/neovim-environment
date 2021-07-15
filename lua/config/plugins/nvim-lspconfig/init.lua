local plug = require("pluginman")
local c = require('config.colours').c
local hl = require('util.highlights')
local set_highlight = hl.set_highlight
local guifg = hl.guifg
local guibg = hl.guibg


plug.add({
  url = "neovim/nvim-lspconfig",
  post_handler = function()
    require("config.plugins.nvim-lspconfig.sumneko")
    require("config.plugins.nvim-lspconfig.tsserver")
    require("config.plugins.nvim-lspconfig.gopls")
    require("config.plugins.nvim-lspconfig.bashls")
    require("config.plugins.nvim-lspconfig.efm")
  end,
  highlight_handler = function()
    local c_error = c.red1
    local c_float_error = c.pearl
    local c_warn = c.red3
    local c_info = c.yellow2
    local c_hint = c.green2

    set_highlight("LspReferenceRead", " gui=underline")
    set_highlight("LspReferenceText", " gui=underline")
    set_highlight("LspReferenceWrite", " gui=underline")

    set_highlight("LspDiagnosticsSignError", guifg(c_error))
    set_highlight("LspDiagnosticsSignWarning", guifg(c_warn))
    set_highlight("LspDiagnosticsSignInformation", guifg(c_info))
    set_highlight("LspDiagnosticsSignHint", guifg(c_hint))

    set_highlight("LspDiagnosticsVirtualTextError", guifg(c_error))
    set_highlight("LspDiagnosticsVirtualTextWarning", guifg(c_warn))
    set_highlight("LspDiagnosticsVirtualTextInformation", guifg(c_info))
    set_highlight("LspDiagnosticsVirtualTextHint", guifg(c_hint))

    set_highlight("LspDiagnosticsUnderlineError", guifg(c_error))
    set_highlight("LspDiagnosticsUnderlineError", " gui=underline,bold")
    set_highlight("LspDiagnosticsUnderlineWarning", guifg(c_warn))
    set_highlight("LspDiagnosticsUnderlineInformation", guifg(c_info))
    set_highlight("LspDiagnosticsUnderlineHint", guifg(c_hint))

    set_highlight("LspDiagnosticsFloatingError", guifg(c_float_error))
    set_highlight("LspDiagnosticsFloatingWarning", guifg(c_warn))
    set_highlight("LspDiagnosticsFloatingInformation", guifg(c_info))
    set_highlight("LspDiagnosticsFloatingHint", guifg(c_hint))

    -- Set to same as PMenu, PMenu is the autocomplete/wildcard
    -- These are the float windows like diagnstic and hover
    set_highlight("NormalFloat", {guifg(c.pearl), guibg(c.blue4)})
    set_highlight("FloatBorder", {guifg(c.text), guibg(c.blue4)})
    -- fixes the weird line break wrong colour blocks
    set_highlight("mkdLineBreak", {guifg(c.pearl), guibg(c.blue4)})

    vim.api.nvim_exec([[
    sign define LspDiagnosticsSignError text=E texthl=LspDiagnosticsSignError linehl= numhl=
    sign define LspDiagnosticsSignWarning text=W texthl=LspDiagnosticsSignWarning linehl= numhl=
    sign define LspDiagnosticsSignInformation text=I texthl=LspDiagnosticsSignInformation linehl= numhl=
    sign define LspDiagnosticsSignHint text=H texthl=LspDiagnosticsSignHint linehl= numhl=
    ]], false)
  end
})
