local s = require("luasnip").snippet
local t = require("luasnip").text_node

local snippets = {
  s("nice-format", {t({
    ":setvar SQLCMDMAXVARTYPEWIDTH 30",
    ":setvar SQLCMDMAXFIXEDTYPEWIDTH 30"
  })})
}

return snippets
