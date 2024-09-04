lazyFileTypes = { "markdown", "yaml", "bash", "dockerfile", "terraform", "terraform-vars", "lua", "typescript", "javascript" }

return {
  -- neodev
  {
    "folke/neodev.nvim",
    lazy = true,
    opts = {
      -- library = {
      --   runtime = "~/projects/neovim/runtime/",
      -- },
    },
  },

  -- tools
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    config = true,
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      -- Note: this is the mason name value here: https://github.com/williamboman/mason-lspconfig.nvim/blob/main/doc/mason-lspconfig-mapping.txt
      ensure_installed = {
        "actionlint",
        "cfn-lint",
        "eslint_d",
        -- "luacheck",
        "markdownlint",
        "stylua",
        "shellcheck",
        "shfmt",
        -- TODO replace with yamlls?
        -- https://gist.github.com/agentzhao/3e26b980175be65478cc2da577858ae0
        "yamllint",
      },
    },
  },

  {
    "williamboman/mason-lspconfig.nvim",
    ft = lazyFileTypes,
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "bashls",
          "jsonls",
          "helm_ls",
          "yamlls",
          "groovyls",
          "dockerls",
          "tsserver",
          "jdtls",
          "prettierd",
          "terraformls",
          "helm_ls",
          "markdown_oxide",
        },
      })

      local buildCapabilities = function()
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        -- be nice to have this wrapped but the plugin isn't loaded at this point...
        capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
        return capabilities
      end

      require("mason-lspconfig").setup_handlers({

        -- The first entry (without a key) will be the default handler
        -- and will be called for each installed server that doesn't have
        -- a dedicated handler.
        function(server_name) -- default handler (optional)
          -- JDTLS is managed differently via the mfussenegger/nvim-jdtls plugin
          if server_name == "jdtls" then
            return
          end

          require("lspconfig")[server_name].setup({
            capabilities = buildCapabilities(),
          })
        end,

        ["jsonls"] = function()
          require("lspconfig").jsonls.setup({
            capabilities = buildCapabilities(),
            settings = {
              json = {
                schemas = require("schemastore").json.schemas(),
                validate = { enable = true },
              },
            },
          })
        end,
        ["yamlls"] = function()
          require("lspconfig").yamlls.setup({
            capabilities = buildCapabilities(),
            settings = {
              json = {
                schemas = require("schemastore").json.schemas(),
                validate = { enable = true },
              },
            },
          })
        end,
        ["groovyls"] = function()
          local home = vim.fn.getenv("HOME")
          local lib_dir =
            "/.local/share/nvim/mason/packages/groovy-language-server/build/libs/groovy-language-server-all.jar"
          require("lspconfig").groovyls.setup({
            capabilities = buildCapabilities(),
            cmd = { "java", "-jar", home .. lib_dir },
          })
        end,
      })
    end,

    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
      { "mfussenegger/nvim-jdtls", ft = "java" },
      "b0o/SchemaStore.nvim",
    },
  },


  { "mfussenegger/nvim-jdtls", ft = "java" },

  -- lsp servers
  {
    "neovim/nvim-lspconfig",
    ft = lazyFileTypes,
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local set = vim.keymap.set
          local opts = { buffer = ev.buf }

          -- TODO have a func to prefix vsplit/splt/tabnew wrapper
          set("n", "gd", require("telescope.builtin").lsp_definitions, opts)

          set("n", "gsd", function()
            vim.cmd("vsplit")
            require("telescope.builtin").lsp_definitions()
          end, opts)

          set("n", "ghd", function()
            vim.cmd("split")
            require("telescope.builtin").lsp_definitions()
          end, opts)

          set("n", "gD", vim.lsp.buf.declaration, opts)
          set("n", "gsD", "<Cmd>vsplit <BAR> lua vim.lsp.buf.declaration()<CR>", opts)
          set("n", "ghD", "<Cmd>split <BAR> lua vim.lsp.buf.declaration()<CR>", opts)
          -- TODO save and restore mark?
          set("n", "gtD", "mt<Cmd>tabnew % <CR> `t <Cmd> lua vim.lsp.buf.declaration()<CR>", opts)
          set("n", "K", vim.lsp.buf.hover, opts)
          -- luacheck: ignore
          set(
            "n",
            "<leader>cf",
            '<Cmd>lua vim.diagnostic.goto_next()<CR><Cmd>lua require("lsp.codeactions").fix_first_code_action()<CR>',
            opts
          )
          -- luacheck: ignore
          set(
            "n",
            "<leader>cF",
            '<Cmd>lua vim.diagnostic.goto_prev()<CR><Cmd>lua require("lsp.codeactions").fix_first_code_action()<CR>',
            opts
          )
          set("n", "gI", "<cmd>Telescope lsp_implementations<CR>", opts)
          set("n", "<space>gss", "<cmd>Telescope lsp_document_symbols<CR>", opts)
          set("n", "K", vim.lsp.buf.signature_help, opts)
          set("n", "<space>D", vim.lsp.buf.type_definition, opts)
          set("n", "<space>vD", "<cmd>vsplit <BAR> lua vim.lsp.buf.type_definition()<CR>", opts)
          set("n", "<space>hD", "<cmd>split <BAR> lua vim.lsp.buf.type_definition()<CR>", opts)
          set("n", "<space>rn", require("scratch.lsp_rename_popup").rename, opts)
          set("n", "gr", "<Cmd>Telescope lsp_references<CR>", opts)
          set("n", "<space>e", vim.diagnostic.open_float, opts)
          set("n", "<space>ge", "<cmd>Telescope diagnostics<CR>", opts)
          set("n", "[d", vim.diagnostic.goto_prev, opts)
          set("n", "]d", vim.diagnostic.goto_next, opts)
          set("n", "<space>th", require("lsp.diagnostics").diagnostic_toggle_virtual_text, opts)
          set({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, opts)

          -- TODO this is fucking gross, but quickfix
          -- Tried to do filetype mapping but isn't picked up for some reason when vim starts, only when explicitly settings
          -- the filetype to go in the command line... user that is a bug though
          if vim.bo.filetype == "go" then
            set("n", "<space>fd", "<cmd>silent! wall<cr><cmd>GoImport<CR>", opts)
          else
            set("n", "<space>fd", function()
              vim.lsp.buf.format({
                filter = function(client)
                  return client.name == "null-ls"
                end,
                async = true,
              })
            end, bufopts)
          end
          -- -- Enable completion triggered by <c-x><c-o>
          -- vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

          -- -- Buffer local mappings.
          -- -- See `:help vim.lsp.*` for documentation on any of the below functions
          -- local opts = { buffer = ev.buf }
          -- vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
          -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          -- vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          -- vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
          -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
          -- vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
          -- vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
          -- vim.keymap.set('n', '<space>wl', function()
          --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          -- end, opts)
          -- vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
          -- vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
          -- vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts)
          -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
          -- vim.keymap.set('n', '<space>f', function()
          --   vim.lsp.buf.format { async = true }
          -- end, opts)
        end,
      })
    end,
  },

  -- null-ls
  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      "nvimtools/none-ls-extras.nvim",
    },
    ft = lazyFileTypes,
    config = function()
      local nls = require("null-ls")
      nls.setup({
        debounce = 1000,
        sources = {
          -- lua
          nls.builtins.formatting.stylua,
          -- nls.builtins.diagnostics.luacheck.with({
          --   condition = function(utils)
          --     return utils.root_has_file({ ".luacheckrc" })
          --   end,
          -- }),

          -- bash/shell
          -- nls.builtins.code_actions.shellcheck,
          -- nls.builtins.diagnostics.shellcheck,
          nls.builtins.formatting.prettierd,
          nls.builtins.formatting.shfmt,
          nls.builtins.formatting.terraform_fmt,

          -- javascript/typescript
          -- nls.builtins.diagnostics.eslint_d,
          require("none-ls.diagnostics.eslint_d"), --from none-ls-extras.nvim
          require("none-ls.formatting.eslint_d"), --from none-ls-extras.nvim
          require("none-ls.code_actions.eslint_d"), --from none-ls-extras.nvim
          -- cloudformation
          nls.builtins.diagnostics.cfn_lint,

          -- refactoring
          nls.builtins.code_actions.refactoring,

          -- git
          nls.builtins.code_actions.gitsigns,

          -- github actions
          nls.builtins.diagnostics.actionlint.with({
            filetypes = { "yaml.github" },
          }),

          -- nls.builtins.diagnostics.markdownlint,
        },
      })
    end,
  },

  -- -- inlay hints
  -- {
  --   "lvimuser/lsp-inlayhints.nvim",
  --   event = "LspAttach",
  --   opts = {},
  --   config = function(_, opts)
  --     require("lsp-inlayhints").setup(opts)
  --     vim.api.nvim_create_autocmd("LspAttach", {
  --       group = vim.api.nvim_create_augroup("LspAttach_inlayhints", {}),
  --       callback = function(args)
  --         if not (args.data and args.data.client_id) then
  --           return
  --         end
  --         local client = vim.lsp.get_client_by_id(args.data.client_id)
  --         require("lsp-inlayhints").on_attach(client, args.buf)
  --       end,
  --     })
  --   end,
  -- },
}
