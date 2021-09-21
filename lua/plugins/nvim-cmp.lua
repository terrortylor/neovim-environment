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
  end

  addSource("buffer")

  if vim.fn.getenv("TMUX") then
    addSource("tmux")
  end

  require('cmp').setup.buffer({sources = sources})
end

function M.setup()
  local cmp = require('cmp')
  local luasnip = require 'luasnip'
  cmp.setup({
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
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.close(),
      ['<CR>'] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      },
    },
  })

  require('util.config').create_autogroups({
    cmp_setup_sources = {
      {"FileType", "*", ":silent! lua require'plugins.nvim-cmp'.setup_sources()"}
    },
  })
end

return M
