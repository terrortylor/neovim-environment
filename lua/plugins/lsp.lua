lazyFileTypes = { "markdown", "markdown.note", "bash", "dockerfile", "terraform", "terraform-vars", "lua", "typescript", "javascript", "go" }

return {
  -- neodev
  {
    "folke/neodev.nvim",
    lazy = true,
    opts = {
    },
  },

  -- tools
  -- Mason to install tooling
  {
    "williamboman/mason.nvim",
  --   ft = lazyFileTypes,
    cmd = "Mason",
    build = ":MasonUpdate",
    config = true,
  },

  -- Mason lsp-config to actually install required tooling
  -- using Mason
  {
    "mason-org/mason-lspconfig.nvim",
    ft = lazyFileTypes,
    opts = {},
    dependencies = {
        { "mason-org/mason.nvim", opts = {
        ensure_installed = {
          "bashls",
          "gopls",
          "jsonls",
          "helm_ls",
          "yamlls",
          "groovyls",
          "dockerls",
          -- "tsserver",
          "jdtls",
          "terraformls",
          "helm_ls",
          "markdown_oxide",
        },
        } },
        "neovim/nvim-lspconfig",
    },
},

{ "mfussenegger/nvim-jdtls", ft = "java" },

  -- LSP server configurations
  {
    "neovim/nvim-lspconfig",
    ft = lazyFileTypes,
    config = function()

      vim.lsp.config('markdown_oxide', {
        filetypes = {'markdown', 'markdown.note' },
      })

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
          -- set("n", "K", vim.lsp.buf.signature_help, opts)
          set("n", "<space>D", vim.lsp.buf.type_definition, opts)
          set("n", "<space>vD", "<cmd>vsplit <BAR> lua vim.lsp.buf.type_definition()<CR>", opts)
          set("n", "<space>hD", "<cmd>split <BAR> lua vim.lsp.buf.type_definition()<CR>", opts)
          set("n", "<space>rn", vim.lsp.buf.rename, opts)
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
          -- if vim.bo.filetype == "go" then
          --   set("n", "<space>fd", "<cmd>silent! wall<cr><cmd>GoImport<CR>", opts)
          -- else
          --   set("n", "<space>fd", function()
          --     print("alex1")
          --     require("conform").format({ lsp_format = "fallback" })
          --     -- vim.lsp.buf.format({
          --     --   filter = function(client)
          --     --     print("alex")
          --     --     print(client)
          --     --     return client.name == "null-ls"
          --     --   end,
          --     --   async = true,
          --     -- })
          --   end, bufopts)
          -- end
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

  {
    "stevearc/conform.nvim",
    dependencies = { "mason.nvim" },
    -- lazy = true,
    opts = {
        formatters_by_ft = {
          lua = { "stylua" },

          -- You can customize some of the format options for the filetype (:help conform.format)
          markdown = { "markdownlint-cli2", lsp_format = "fallback" },
          -- Conform will run the first available formatter
          javascript = { "prettierd", "prettier", stop_after_first = true },
        },
        -- format_on_save = {
        --   -- These options will be passed to conform.format()
        --   timeout_ms = 500,
        --   lsp_format = "fallback",
        -- },
      },
    -- cmd = "ConformInfo",
    keys = {
      {
      "<leader>fd",
      function()
        require("conform").format({ async = true })
      end,
      mode = "",
      desc = "Format buffer",
      {remap = true},
    },
    },
  },
}
