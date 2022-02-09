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
  -- addSource("nvim_lsp_signature_help", "[SIG]")

  require('cmp').setup.buffer({sources = sources})
end

function M.setup()
    local has_words_before = function()
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
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
      formatting = {
        format = function(entry, vim_item)
          vim_item.menu = menu[entry.source.name]
          return vim_item
        end,
      },
      mapping = {
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-e>'] = cmp.mapping.abort(),

        -- TAB
        -- will select and confirm top unselected PUM item
        -- or confirm selected PUM item
        -- if no PUM is visiable then trys luasnip expand or jump
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() and cmp.get_selected_entry() ~= nil then
            cmp.confirm {
              behavior = cmp.ConfirmBehavior.Replace,
              select = true,
            }
          elseif cmp.visible() and cmp.get_selected_entry() == nil then
            cmp.select_next_item()
            cmp.confirm {
              behavior = cmp.ConfirmBehavior.Replace,
              select = true,
            }
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
    })

    cmp.setup.cmdline('/', {
      sources = {
        { name = 'buffer' }
      }
    })

    cmp.setup.cmdline(':', {
      sources = cmp.config.sources({
        { name = 'path' }
      }, {
        { name = 'cmdline' }
      })
    })

    require('util.config').create_autogroups({
      cmp_setup_sources = {
        {"FileType", "*", ":silent! lua require'plugins.nvim-cmp'.setup_sources()"}
      },
    })
  end

return M
