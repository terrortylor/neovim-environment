return {
  {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    config = function()
      local luasnip = require("luasnip")
      luasnip.config.set_config({
        history = true,
        updateevents = "TextChanged,TextChangedI",
        enable_autosnippets = true,
        store_selection_keys = "<Tab>",
      })

      require("luasnip.loaders.from_lua").lazy_load({ paths = "./luasnippets" })
      require("luasnip.loaders.from_snipmate").lazy_load({ paths = "./snippets" })
      vim.api.nvim_create_user_command(
        "LuaSnipUpdate",
        'lua require("luasnip.loaders.from_lua").load({paths = "~/.config/nvim/LuaSnip/"})',
        { force = true }
      )
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    config = function()
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local cmp = require("cmp")
      local luasnip = require("luasnip")
      cmp.setup({
        -- THIS IS THE FUCKING KEY!
        preselect = cmp.PreselectMode.None,
        window = {
          completion = {
            border = "rounded",
          },
          documentation = {
            border = "rounded",
          },
        },
        snippet = {
          expand = function(args)
            if luasnip then
              luasnip.lsp_expand(args.body)
            end
          end,
        },
        mapping = {
          -- ["<C-k>"] = cmp.mapping.select_prev_item(),
          -- ["<C-j>"] = cmp.mapping.select_next_item(),
          ["<Up>"] = cmp.mapping.select_prev_item(),
          ["<Down>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-e>"] = cmp.mapping.abort(),

          -- TAB
          -- will select and confirm top unselected PUM item
          -- or confirm selected PUM item
          -- if no PUM is visiable then trys luasnip expand or jump
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              if cmp.get_selected_entry() == nil then
                cmp.select_next_item()
              end
              cmp.confirm({
                behavior = cmp.ConfirmBehavior.Replace,
                select = true,
              })
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        },
        sources = cmp.config.sources({
          { name = "luasnip" },
          { name = "nvim_lsp" },
          { name = "nvim_lsp_document_symbol" },
          { name = "path" },
          {
            name = "tmux",
            keyword_length = 6,
            option = {
              keyword_pattern = [[\w\w\w\w\+]],
            },
            max_item_count = 5,
            priorty = 1000,
          },
          { name = "spell" },
          { name = "neorg" },
          { name = "buffer" },
        }),
      })

      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
          { name = "cmdline" },
        }),
      })
    end,

    dependencies = {
      "L3MON4D3/LuaSnip",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-document-symbol",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      "andersevenrud/cmp-tmux",
      -- "~/personal-workspace/nvim-plugins/cmp-tmux",
      "f3fora/cmp-spell",
      "hrsh7th/cmp-nvim-lua",
      -- "hrsh7th/cmp-nvim-lsp-signature-help"
    },
  },
}
