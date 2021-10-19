local M = {}

-- could be moved to utils
local function prequire(...)
  local status, lib = pcall(require, ...)
  if (status) then return lib end
  return nil
end

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
  local line_only_whitespace = function()
    local line, _ = unpack(vim.api.nvim_win_get_cursor(0))
    print("ere", vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:match("^%s*$"))
    return vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:match("^%s*$") ~= nil
  end

  local cmp = require('cmp')
  local luasnip = prequire ('luasnip')
  cmp.setup({
    -- THIS IS THE FUCKING KEY!
    preselect = cmp.PreselectMode.None,
    snippet = {
      expand = function(args)
        if luasnip then
          luasnip.lsp_expand(args.body)
        end
      end,
    },
    mapping = {
      ['<C-p>'] = cmp.mapping.select_prev_item(),
      ['<C-n>'] = cmp.mapping.select_next_item(),
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<TAB>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }
        elseif line_only_whitespace() then
          fallback()
        elseif luasnip and luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end, {'i', 's'}),
      ['<S-Tab>'] = cmp.mapping(function(fallback)
        if luasnip and luasnip.jumpable(-1) then
          luasnip.jump(-1)
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
