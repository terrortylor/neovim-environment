-- Colours inspired by tender colur scheme

local function lsp_highlights()
  print("highlights")
  vim.api.nvim_exec([[
    highlight LspReferenceRead gui=underline
    highlight LspReferenceText gui=underline
    highlight LspReferenceWrite gui=underline

    sign define LspDiagnosticsSignError text=E texthl=LspDiagnosticsSignError linehl= numhl=
    sign define LspDiagnosticsSignWarning text=W texthl=LspDiagnosticsSignWarning linehl= numhl=
    sign define LspDiagnosticsSignInformation text=I texthl=LspDiagnosticsSignInformation linehl= numhl=
    sign define LspDiagnosticsSignHint text=H texthl=LspDiagnosticsSignHint linehl= numhl=

    highlight LspDiagnosticsSignError guifg=#f43753
    highlight LspDiagnosticsSignWarning guifg=#79313c
    highlight LspDiagnosticsSignInformation guifg=#ffc24b
    highlight LspDiagnosticsSignHint guifg=#9faa00

    highlight LspDiagnosticsSignError guifg=#f43753
    highlight LspDiagnosticsSignWarning guifg=#79313c
    highlight LspDiagnosticsSignInformation guifg=#ffc24b
    highlight LspDiagnosticsSignHint guifg=#9faa00

    highlight LspDiagnosticsVirtualTextError guifg=#f43753
    highlight LspDiagnosticsVirtualTextWarning guifg=#79313c
    highlight LspDiagnosticsVirtualTextInformation guifg=#ffc24b
    highlight LspDiagnosticsVirtualTextHint guifg=#9faa00

    highlight LspDiagnosticsUnderlineError guifg=#f43753
    highlight LspDiagnosticsUnderlineError gui=underline,bold
    highlight LspDiagnosticsUnderlineWarning guifg=#79313c
    highlight LspDiagnosticsUnderlineInformation guifg=#ffc24b
    highlight LspDiagnosticsUnderlineHint guifg=#9faa00

    highlight LspDiagnosticsFloatingError guifg=#dadada
    highlight LspDiagnosticsFloatingWarning guifg=#79313c
    highlight LspDiagnosticsFloatingInformation guifg=#ffc24b
    highlight LspDiagnosticsFloatingHint guifg=#9faa00

    " Set to same as PMenu, PMenu is the autocomplete/wildcard
    " These are the float windows like diagnstic and hover
    highlight NormalFloat guifg=#dadada guibg=#335261
  ]], false)
end

return lsp_highlights()
