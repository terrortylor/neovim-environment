local M = {}

local function setup_snippets()
  local ls = require"luasnip"

  local s = ls.snippet
  -- local sn = ls.snippet_node
  -- local isn = ls.indent_snippet_node
  local t = ls.text_node
  -- local i = ls.insert_node
  -- local f = ls.function_node
  -- local c = ls.choice_node
  -- local d = ls.dynamic_node

  ls.snippets = {
    all = {
    },
    sql = {
      s("nice-format", {t({
        ":setvar SQLCMDMAXVARTYPEWIDTH 30",
        ":setvar SQLCMDMAXFIXEDTYPEWIDTH 30"
      })})
    }
  }

  local function get_snippets_rtp()
    return vim.tbl_map(function(itm)
      return vim.fn.fnamemodify(itm, ":h")
    end, vim.api.nvim_get_runtime_file(
    "package.json",
    true
    ))
  end


  -- Adds custom snippets in vscode format over top of friendly-snippets
  -- but doesn't override them, whihc would be better
  local paths = get_snippets_rtp()
  table.insert(paths, "./snippets")
  require("luasnip.loaders.from_vscode").load({paths = paths})
end

local function setup_keymaps()
  local ls = require"luasnip"

  local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
  end

  local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
      return true
    else
      return false
    end
  end

  _G.tab_complete = function()
    if vim.fn.pumvisible() == 1 then
      return t("<C-n>")
    elseif ls and ls.expand_or_jumpable() then
      return t("<Plug>luasnip-expand-or-jump")
    elseif check_back_space() then
      return t("<Tab>")
    else
      return vim.NIL
    end
  end

  _G.s_tab_complete = function()
    if vim.fn.pumvisible() == 1 then
      return t("<C-p>")
    elseif ls and ls.jumpable(-1) then
      return t("<Plug>luasnip-jump-prev")
    else
      return t("<S-Tab>")
    end
  end

  vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
  vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
  vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
  vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
  vim.api.nvim_set_keymap("i", "<C-E>", "<Plug>luasnip-next-choice", {})
  vim.api.nvim_set_keymap("s", "<C-E>", "<Plug>luasnip-next-choice", {})
end

function  M.setup()
  setup_snippets()
  setup_keymaps()
end

return M
