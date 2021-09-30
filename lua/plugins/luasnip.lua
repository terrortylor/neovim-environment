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

function  M.setup()
  setup_snippets()
  -- keymaps setup in nvim-cmp config
end

return M
