local common = require("plugins.lsp.common")
-- set the path to the sumneko installation; if you previously installed via the now deprecated :LspInstall, use
-- local sumneko_root_path = "/opt/lua-language-server"
-- local sumneko_binary = sumneko_root_path .. "/bin/lua-language-server"

local sumneko_binary_path = vim.fn.exepath('lua-language-server')
local sumneko_root_path = vim.fn.fnamemodify(sumneko_binary_path, ':h:h:h')

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

require("lspconfig").sumneko_lua.setup({
  on_attach = common.on_attach,
  capabilities = common.buildCapabilities(),
  -- cmd = { sumneko_binary_path, "-E", sumneko_root_path .. "/main.lua" },
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
        -- Setup your lua path
        -- path = vim.split(package.path, ";"),

            -- Setup your lua path
            path = runtime_path,
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { "vim", "describe", "before_each", "after_each", "it" },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files

        -- library = vim.api.nvim_get_runtime_file("", true),
        -- checkThirdParty = false,

        library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
        },

      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
})

