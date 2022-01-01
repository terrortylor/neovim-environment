local p = require("luasnip").parser.parse_snippet

local snippets = {
  p({ trig = "ignore" }, '-- luacheck: ignore'),
}

return snippets
