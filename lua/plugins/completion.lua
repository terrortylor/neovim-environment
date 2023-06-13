return {
  {
    "L3MON4D3/LuaSnip",
    -- install jsregexp (optional!).
    build = "make install_jsregexp",
    config = function()
      local function edit_ft()
        -- returns table like {"lua", "all"}
        local fts = require("luasnip.util.util").get_snippet_filetypes()

        -- add mapping for either ft in snipmate format or ft in luasnip (lua) file
        local non_all = {}
        for _, v in ipairs(fts) do
          if v ~= "all" then
            table.insert(non_all, v .. " | snipmate")
            table.insert(non_all, v .. " | luasnip")
          end
        end
        table.insert(non_all, "all | snipmate")
        table.insert(non_all, "all | luasnip")

        vim.ui.select(non_all, {
          prompt = "Select which filetype to edit:",
        }, function(item, idx)
          -- selection aborted -> idx == nil
          if idx then
            local ft, style = item:match("(.*) | (.*)")
            if style == "snipmate" then
              vim.cmd("edit ~/.config/nvim/snippets/" .. ft .. ".snippets")
            else
              vim.cmd("edit ~/.config/nvim/luasnippets/" .. ft .. ".lua")
            end
            -- TODO on buffer change/close then re-run the setup() below to reload
          end
        end)
      end

      vim.api.nvim_create_user_command("LuaSnipEdit", edit_ft, { force = true })
      require("luasnip.loaders.from_snipmate").lazy_load()
      -- require("luasnip.loaders.from_lua").lazy_load({ paths = "./luasnippets" })
      -- vim.keymap.set("i", "<c-j>", function()
      --   require("luasnip").jump(1)
      -- end, { desc = "luasnip next" })
      -- vim.keymap.set("i", "<c-k>", function()
      --   require("luasnip").jump(-1)
      -- end, { desc = "luasnip previous" })
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
