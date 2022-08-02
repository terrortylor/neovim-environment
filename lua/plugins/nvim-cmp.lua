local M = {}

-- could be moved to utils
local function prequire(...)
  local status, lib = pcall(require, ...)
  if status then
    return lib
  end
  return nil
end

function M.setup()
  local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
  end

  local cmp = require("cmp")
  local luasnip = prequire("luasnip")
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
      ["<C-k>"] = cmp.mapping.select_prev_item(),
      ["<C-j>"] = cmp.mapping.select_next_item(),
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
      { name = "path" },
    }),
  })

  cmp.setup.cmdline("/", {
    sources = {
      { name = "buffer" },
    },
  })

  cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = "path" },
    }, {
      { name = "cmdline" },
    }),
  })

  cmp.setup.filetype({
    'go',
    'typescript',
    'javascript',
  }, {
    sources = {
      { name = 'nvim_lsp' },
      { name = "luasnip" },
      { name = "path" },
    }
  })

  cmp.setup.filetype('lua',
    {
      sources = {
        { name = 'nvim_lsp' },
        { name = 'nvim_lua' },
        { name = "luasnip" },
        { name = "path" },
      }
    })

  cmp.setup.filetype({
    'markdown',
  }, {
    sources = {
      { name = 'spell' },
      { name = "luasnip" },
      { name = "path" },
    }
  })

  cmp.setup.filetype({
    'org',
  }, {
    sources = {
      { name = 'spell' },
      { name = 'neorg' },
      { name = "luasnip" },
      { name = "path" },
    }
  })

  cmp.setup.filetype({
    'tmux',
  }, {
    sources = {
      { name = 'tmux' },
      { name = "luasnip" },
      { name = "path" },
    },
  })

  cmp.setup.filetype('terraform', {
    sources = {
      { name = 'nvim_lsp' },
      { name = 'buffer' },
      { name = 'spell' },
      { name = "luasnip" },
      { name = "path" },
    }
  })

end

return M
