local p = require("luasnip").parser.parse_snippet

local snippets = {
  p({ trig = "print" }, 'echo ${2:"}${1:$TM_SELECTED_TEXT}${2}'),
}

return snippets
