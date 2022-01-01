local p = require("luasnip").parser.parse_snippet

local snippets = {
  -- luacheck: ignore
  p({ trig = "newhttp" }, '${1:www.blablabla.com}\n${2:${3:POST /posts}\n${4:HEADER: Content-Type: application/json; charset=UTF-8}\n${5:id: 100}\n${6:@filename.txt}}'),
}

return snippets
