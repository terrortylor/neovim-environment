local s = require("luasnip").snippet
local t = require("luasnip").text_node
local p = require("luasnip").parser.parse_snippet

local snippets = {
    p({ trig = "ti" }, 'type $1 interface {\n\t$0\n}'),
    p({ trig = "ts" }, 'type $1 struct {\n\t$0\n}'),
    p({ trig = "mock_controller" }, 'ctrl := gomock.NewController(t)\ndefer ctrl.Finish()\n$0'),
    -- luacheck: ignore
    p({ trig = "mock_generation" }, '//go:generate mockgen -source=\\$GOFILE -destination=mock_\\$GOFILE -package=\\$GOPACKAGE'),
    -- luacheck: ignore
    p({ trig = "pretty_print_struct" }, 'prettyStruct, err := json.MarshalIndent(${1:$TM_SELECTED_TEXT}, "", "  ")\nif err != nil {\n\tlog.Fatalf(err.Error())\n}\nfmt.Printf("MarshalIndent funnction output %s\\n", string(prettyStruct))'),
    p({ trig = "interface_check" }, 'var _ ${1:INTERFACE} = (*${2:STUCT})(nil)'),
    p({ trig = "fprint" }, 'fmt.Printf("$1\\n", $2)$0'),
    p({ trig = "fori" }, 'for ${1:i} := ${2:0}; $1 < ${3:count}; $1${4:++} {\n\t$0\n}'),
    p({ trig = "forrange" }, 'for ${1:_, }${2:v} := range ${3:list} {\n\t$0\n}'),
    p({ trig = "fpf" }, 'fmt.Printf(\"$1\", $2)\n$0'),
    p({ trig = "switch" }, 'switch ${1:expression} {\ncase ${2:condition}:\n\t$0\n}'),
    -- test table wrapped in a fun
    p({ trig = "functest", name = "Test" },
    "func Test$1(t *testing.T) {\n\t$0\n}"),
    p({ trig = "tt", name = "Test Table" },
    [[
    testcases := []struct {
      name  string
      $2
    }{
      {
        name: "$3",
        $4
      },
    }
    for _, tc := range testcases {
      t.Run(tc.name, func(t *testing.T) {
        $0
      })
    }
    ]]),
    p("iferr", "if err ${1:!=} nil {\n\treturn ${2:err}\n}\n$0"),
    p({ trig = "if", name = "if" }, "if $1 {\n\t${0:$TM_SELECTED_TEXT}\n}"),
    s({ trig = "testserver", name = "httptest.NewServer" }, {t({
      'ts := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {',
      '    t.Fatalf("Did not expect call: %s %s\\n", r.Method, r.URL.Path)',
      "}))"
    })}),
    p({ trig = "filterinplace", name = "Filter in place" },
    [[
    ${1:n} := 0
    for _, ${2:x} := range ${3:input} {
      if ${4:$2 == true} {
        $3[$1] = $2
        $1++
      }
    }
    $3 = $3[:$1]
    ]]),
    p({ trig = "filter", name = "Filterplace" },
    [[
    ${1:filtered} := []${2:string\{\}}
    for _, ${2:v} := range ${3:input} {
      if ${4:$2 == true} {
        $1 = append($1, $2)
      }
    }
    ]]),
}

return snippets
