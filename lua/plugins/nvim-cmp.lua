local M = {}

-- could be moved to utils
local function prequire(...)
  local status, lib = pcall(require, ...)
  if (status) then return lib end
  return nil
end

local menu = {}
function M.setup_sources()
  local sources = {}

  local addSource = function(name, menu_val)
    if type(name) == 'string' then
      table.insert(sources, {name = name})
      menu[name] = menu_val
    else
      table.insert(sources, name)
      menu[name.name] = menu_val
    end
  end

  local ft = vim.bo.filetype

  addSource("luasnip", "[SNIP]")

  local lsp_filetytpe = {
    "go",
    "typescript",
    "javascript",
    "lua"
  }
  if vim.tbl_contains(lsp_filetytpe, ft) then
    addSource("nvim_lsp", "[LSP]")
  else
    addSource({name = "buffer", keyword_length = 4}, "[BUF]")
  end

  local spelling_filetypes = {
    "markdown",
    "wiki.markdown",
    "org",
  }
  if vim.tbl_contains(spelling_filetypes, ft) then
    addSource({name = "spell", keyword_length = 4}, "[SPELL]")
  end

  if ft == "org" then
    addSource("orgmode", "[ORG]")
  end

  if ft == "norg" then
    addSource("neorg", "[NORG]")
  end

  if vim.fn.getenv("TMUX") then
    addSource({ name = "tmux", keyword_length = 4, max_item_count = 5 }, "[TMUX]")
  end

  require('cmp').setup.buffer({sources = sources})
  -- print(vim.inspect(sources))
end

function M.setup()
  -- local line_only_whitespace = function()
  --   local line, _ = unpack(vim.api.nvim_win_get_cursor(0))
  --   return vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:match("^%s*$") ~= nil
  -- end

  local cmp = require('cmp')
  local luasnip = prequire ('luasnip')
  cmp.setup({
    -- THIS IS THE FUCKING KEY!
    preselect = cmp.PreselectMode.None,
    -- completion = {autocomplete = true},
    snippet = {
      expand = function(args)
        if luasnip then
          luasnip.lsp_expand(args.body)
        end
      end,
    },
    formatting = {
      format = function(entry, vim_item)
        vim_item.menu = menu[entry.source.name]
        return vim_item
      end,
    },
    mapping = {
      ['<C-p>'] = cmp.mapping.select_prev_item(),
      ['<C-n>'] = cmp.mapping.select_next_item(),
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-e>'] = cmp.mapping.abort(),
      ["<c-y>"] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Insert,
        select = true,
      },
      ["<c-q>"] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      },

      ['<CR>'] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      }),
--       ["<Tab>"] = cmp.mapping(function(fallback)
--         if cmp.visible() then
--           cmp.select_next_item()
--         elseif luasnip and luasnip.expand_or_jumpable() then
--           luasnip.expand_or_jump()
--         elseif has_words_before() then
--           cmp.complete()
--         else
--           fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
--         end
--       end, { "i", "s" }),

--       ["<S-Tab>"] = cmp.mapping(function()
--         if cmp.visible() then
--           cmp.select_prev_item()
--         elseif luasnip and luasnip.jumpable(-1) then
--           luasnip.jump(-1)
--         end
--       end, { "i", "s" }),

      -- ['<TAB>'] = cmp.mapping(function(fallback)
      --   if cmp.get_selected_entry() == nil then
      --     print("is nil")
      --   end
      --   -- if cmp.visible() then
      --   if cmp.visible() and cmp.get_selected_entry() ~= nil then
      --     print("in confirm")
      --     cmp.confirm {
      --       behavior = cmp.ConfirmBehavior.Replace,
      --       select = true,
      --     }
      --   elseif line_only_whitespace() then
      --     print("in whitespace")
      --     fallback()
      --   -- elseif luasnip and luasnip.expand_or_jumpable() then
      --   --   print("injump")
      --   --   luasnip.expand_or_jump()
      --   elseif luasnip and luasnip.jumpable(1) then
      --     print("in jump")
      --     luasnip.jump(1)
      --   else
      --     print("in fallback")
      --     fallback()
      --   end
      -- end, {'i', 's'}),
      -- ['<S-Tab>'] = cmp.mapping(function(fallback)
      --   if luasnip and luasnip.jumpable(-1) then
      --     luasnip.jump(-1)
      --   else
      --     fallback()
      --   end
      -- end, {'i', 's'}),
    },
  })

  require('util.config').create_autogroups({
    cmp_setup_sources = {
      {"FileType", "*", ":silent! lua require'plugins.nvim-cmp'.setup_sources()"}
    },
  })
end

return M