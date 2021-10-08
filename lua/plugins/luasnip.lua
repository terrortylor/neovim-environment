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
      pair("{", "}", neg, char_count_same),
      pair("[", "]", neg, char_count_same),
      pair("<", ">", neg, char_count_same),
      pair("'", "'", neg, even_count),
      pair('"', '"', neg, even_count),
      pair("`", "`", neg, even_count),
      s({trig="{,", wordTrig=false}, { t({"{","\t"}), i(1), t({"", "}"}) }),
      ls.parser.parse_snippet({trig = "tr"}, "if ${1:[[ ${2:word} -eq ${3:word2} ]]}; then\n\t$4\nfi"),
    },
    sql = {
      s("nice-format", {t({
        ":setvar SQLCMDMAXVARTYPEWIDTH 30",
        ":setvar SQLCMDMAXFIXEDTYPEWIDTH 30"
      })})
    },
    go = {
      -- test table wrapped in a fun
      parse_snippet({ trig = "functest", name = "Test" },
      [[
func Test$1(t *testing.T) {
  $0
}
      ]]),
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
      parse_snippet("iferr",
      [[
if err ${1:!=} nil {
  return ${2:err}
}
$0
      ]]),
      parse_snippet({ trig = "fori", name = "for i <= N" },
      [[
${1:i := 1}
for ${2:i <= 3} {
  $0
}
      ]]),
      parse_snippet({ trig = "forr", name = "for range" },
      [[
for ${1:i}, ${2:v} := range ${3:somearray} {
  $0
}
      ]]),
      parse_snippet({ trig = "if", name = "if" },
      [[
if $1 {
  $0
}
      ]]),
    }
  }
end

function  M.setup()
  setup_snippets()
  -- keymaps setup in nvim-cmp config
end

return M
