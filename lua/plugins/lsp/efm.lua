local util = require('lspconfig.util')

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
