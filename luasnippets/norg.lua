local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

local get_visual = function(args, parent)
  if #parent.snippet.env.LS_SELECT_RAW > 0 then
    return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
  else
    return sn(nil, i(1))
  end
end

return {
  s(
    { trig = "note", dscr = "Note with bold prefix" },
    fmt(
      [[
      *NOTE*: {}
    ]],
      { i(1, "bash") }
    )
  ),

  s(
    { trig = "todo", dscr = "Norg todo" },
    fmt(
      [[
      - ( ) {}
    ]],
      { i(1, "bash") }
    )
  ),

  s(
    { trig = "code", dscr = "Norg code block" },
    fmt(
      [[
      @code {}
      {}
      @end
    ]],
      { i(1, "bash"), d(2, get_visual) }
    )
  ),

  s(
    { trig = "link", dscr = "Norg link" },
    fmt(
      [[
      {<>}[<>]
    ]],
      {
        d(1, get_visual),
        i(2, "description"),
      },
      { delimiters = "<>" }
    )
  ),

  s(
    { trig = "ivaas" },
    fmt(
      [[
      {https://orc-id.atlassian.net/browse/IVAAS-<>}[IVAAS-<>] 
    ]],
      {
        d(1, get_visual),
        rep(1),
      },
      { delimiters = "<>" }
    )
  ),
}
