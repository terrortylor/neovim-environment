local p = require("luasnip").parser.parse_snippet

local snippets = {
  p("**", "**${1:BOLD TEXT}**$0"),
}

return snippets
