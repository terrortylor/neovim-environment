local M = {}

function M.setup_sources()
  local sources = {}

  local lsp_filetytpe = {
    "go",
    "typescript",
    "javascript",
    "lua"
  }

  local addSource = function(name)
    table.insert(sources, {name = name})
  end

  local ft = vim.bo.filetype

  addSource("luasnip")

  if vim.tbl_contains(lsp_filetytpe, ft) then
    addSource("nvim_lsp")
  else
    addSource("buffer")
  end

  -- if vim.fn.getenv("TMUX") then
  --   addSource("tmux")
  -- end

  require('cmp').setup.buffer({sources = sources})
end

function M.setup()
  local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
  end

  local cmp = require('cmp')
  local luasnip = require 'luasnip'
  cmp.setup({
    -- THIS IS THE FUCKING KEY!
    preselect = cmp.PreselectMode.None,
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
      end,
    },
    mapping = {
      ['<C-p>'] = cmp.mapping.select_prev_item(),
      ['<C-n>'] = cmp.mapping.select_next_item(),
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<TAB>'] = cmp.mapping(function(fallback)
        if vim.fn.pumvisible() == 1 then
          cmp.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }
        elseif luasnip.expand_or_jumpable() then
          vim.fn.feedkeys(t('<Plug>luasnip-expand-or-jump'), '')
        else
          fallback()
        end
      end, {'i', 's'}),
      ['<S-Tab>'] = cmp.mapping(function(fallback)
        if luasnip.jumpable(-1) then
          vim.fn.feedkeys(t('<Plug>luasnip-jump-prev'), '')
        else
          fallback()
        end
      end, {'i', 's'}),
    },
  })

  require('util.config').create_autogroups({
    cmp_setup_sources = {
      {"FileType", "*", ":silent! lua require'plugins.nvim-cmp'.setup_sources()"}
    },
  })
end

return M
