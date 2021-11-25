-- luacheck: ignore
local M = {}

local function setup_snippets()
  local ls = require"luasnip"

  local s = ls.snippet
  local parse_snippet = ls.parser.parse_snippet
  local t = ls.text_node
  local i = ls.i

  local function char_count_same(c1, c2)
    local line = vim.api.nvim_get_current_line()
    local _, ct1 = string.gsub(line, '%'..c1, '')
    local _, ct2 = string.gsub(line, '%'..c2, '')
    return ct1 == ct2
  end

  local function even_count(c)
    local line = vim.api.nvim_get_current_line()
    local _, ct = string.gsub(line, c, '')
    return ct % 2 == 0
  end

  local function neg(fn, ...)
    return not fn(...)
  end

  local function part(func, ...)
    local args = {...}
    return function() return func(unpack(args)) end
  end

  local function pair(pair_begin, pair_end, expand_func, ...)
    return s({trig = pair_begin, wordTrig=false}, {t({pair_begin}), i(1), t({pair_end})}, {condition = part(expand_func, part(..., pair_begin, pair_end))})
  end

  ls.snippets = {
    all = {
      pair("(", ")", neg, char_count_same),
      -- pair("{", "}", neg, char_count_same),
      pair("[", "]", neg, char_count_same),
      pair("<", ">", neg, char_count_same),
      pair("'", "'", neg, even_count),
      pair('"', '"', neg, even_count),
      pair("`", "`", neg, even_count),
      s({trig="{", wordTrig=false}, { t({"{","\t"}), i(1), t({"", "}"}), i(2) }),
    },
    sql = {
      s("nice-format", {t({
        ":setvar SQLCMDMAXVARTYPEWIDTH 30",
        ":setvar SQLCMDMAXFIXEDTYPEWIDTH 30"
      })})
    },
    html = {
      parse_snippet({ trig = "newhttp" }, '${1:www.blablabla.com}\n${2:${3:POST /posts}\n${4:HEADER: Content-Type: application/json; charset=UTF-8}\n${5:id: 100}\n${6:@filename.txt}}'),
    },
    sh = {
      parse_snippet({ trig = "print" }, 'echo ${2:"}${1:$TM_SELECTED_TEXT}${2}'),
    },
    go = {
      parse_snippet({ trig = "mock_controller" }, 'ctrl := gomock.NewController(t)\ndefer ctrl.Finish()\n$0'),
      parse_snippet({ trig = "mock_generation" }, '//go:generate mockgen -source=\\$GOFILE -destination=mock_\\$GOFILE -package=\\$GOPACKAGE'),
      parse_snippet({ trig = "pretty_print_struct" }, 'prettyStruct, err := json.MarshalIndent(${1:$TM_SELECTED_TEXT}, "", "  ")\nif err != nil {\n\tlog.Fatalf(err.Error())\n}\nfmt.Printf("MarshalIndent funnction output %s\\n", string(prettyStruct))'),
      parse_snippet({ trig = "interface_check" }, 'var _ ${1:INTERFACE} = (*${2:STUCT})(nil)'),
      parse_snippet({ trig = "fprint" }, 'fmt.Printf("$1\\n", $2)$0'),
      -- test table wrapped in a fun
      parse_snippet({ trig = "functest", name = "Test" },
     "func Test$1(t *testing.T) {\n\t$0\n}"),
      parse_snippet({ trig = "tt", name = "Test Table" },
      [[
testcases := []struct {
  name  string
  $2
}{
  {
  desc: "$3",
  $4
  },
}
for _, tc := range testcases {
  t.Run(tc.name, func(t *testing.T) {
  $0
  })
}
      ]]),
      parse_snippet("iferr", "if err ${1:!=} nil {\n\treturn ${2:err}\n}\n$0"),
      parse_snippet({ trig = "if", name = "if" }, "if $1 {\n\t${0:$TM_SELECTED_TEXT}\n}"),
      s({ trig = "testserver", name = "httptest.NewServer" }, {t({
        'ts := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {',
        '    t.Fatalf("Did not expect call: %s %s\\n", r.Method, r.URL.Path)',
        "}))"
      })}),
    },
    markdown = {
      parse_snippet("**", "**${1:BOLD TEXT}**$0"),
    },
    org = {
      parse_snippet("code", "#+NAME: ${1:NAME}\n#+BEGIN_SRC ${2:LANGUAGE}\n${3:CODE}\n#+END_SRC"),
    },
  }
  ls.filetype_extend("wiki.markdown", {"markdown"})
  require("luasnip").config.setup({store_selection_keys="<Tab>"})
end

local function setup_keymaps()

  vim.cmd [[
  imap <silent><expr> <c-k> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<c-k>'
  inoremap <silent> <c-j> <cmd>lua require('luasnip').jump(-1)<CR>

  imap <silent><expr> <C-l> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-l>'

  snoremap <silent> <c-k> <cmd>lua require('luasnip').jump(1)<CR>
  snoremap <silent> <c-j> <cmd>lua require('luasnip').jump(-1)<CR>
]]

end

function  M.setup()
  setup_snippets()
  setup_keymaps()
end

return M
