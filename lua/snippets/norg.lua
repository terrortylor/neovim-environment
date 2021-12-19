local p = require("luasnip").parser.parse_snippet

local snippets = {
  p("code", "@code ${1:language}\n${2:TM_SELECTED_TEXT}\n@end$0"),
  p("link", "[${1}](${2:TM_SELECTED_TEXT})$0"),
}

return snippets
