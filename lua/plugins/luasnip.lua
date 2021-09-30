local M = {}

local function setup_snippets()
  local ls = require"luasnip"

  local s = ls.snippet
  local parse_snippet = ls.parser.parse_snippet
  local t = ls.text_node

  ls.snippets = {
    all = {
    },
    sql = {
      s("nice-format", {t({
        ":setvar SQLCMDMAXVARTYPEWIDTH 30",
        ":setvar SQLCMDMAXFIXEDTYPEWIDTH 30"
      })})
    },
    go = {
      parse_snippet("tt",
      [[
func Test$1(t *testing.T) {
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
