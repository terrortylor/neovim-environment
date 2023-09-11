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
local line_begin = require("luasnip.extras.expand_conditions").line_begin

local function get_visual(args, parent)
  if #parent.snippet.env.LS_SELECT_RAW > 0 then
    return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
  else
    return sn(nil, i(1))
  end
end

local function get_timezone_offset()
  -- http://lua-users.org/wiki/TimeZon
  -- return the timezone offset in seconds, as it was on the time given by ts
  -- Eric Feliksik
  local utcdate = os.date("!*t", 0)
  local localdate = os.date("*t", 0)
  localdate.isdst = false -- this is the trick
  return os.difftime(os.time(localdate), os.time(utcdate))
end

local function get_timestamp()
  -- generate a ISO-8601 timestamp
  -- example: 2023-09-05T09:09:11-0500
  local tz_offset = get_timezone_offset()
  local h, m = math.modf(tz_offset / 3600)
  return os.date("%Y-%m-%dT%H:%M:%S") .. string.format("%+.4d", h * 100 + m * 60)
end

local function neorg_meta_version()
  return require("neorg.core").config.norg_version
end

return {
  s({ trig = "note", dscr = "Note with bold prefix" }, fmt("*NOTE*: {}", { i(1, "bash") })),

  s({ trig = "todo", dscr = "Norg todo" }, fmt("- ( ) {}", { i(1, "bash") })),

  s(
    {
      trig = "^[%s]*(;+)tt",
      descr = "Norg todo, with smart indenting",
      regTrig = true,
      wordTrig = false,
      snippetType = "autosnippet",
    },
    fmt("{} ( ) {}", {
      f(function(_, snip)
        local len = snip.captures[1]:len()
        return string.rep("-", len)
      end),
      d(1, get_visual),
    })
  ),

  s(
    { trig = ";bb", descr = "Norg bold text", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmt("*{}* ", {
      d(1, get_visual),
    })
  ),

  s(
    { trig = "^[%s]*;cc", descr = "Norg code block", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
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
    { trig = ";ll", descr = "Norg link", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmt("{<>}[<>]", {
      d(1, get_visual),
      i(2, "description"),
    }, { delimiters = "<>" })
  ),

  s(
    { trig = "ivaas" },
    fmt("{https://orc-id.atlassian.net/browse/IVAAS-<>}[IVAAS-<>] ", {
      d(1, get_visual),
      rep(1),
    }, { delimiters = "<>" })
  ),

  s(
    { trig = "templatejournal", descr = "Template for Journal entry", regTrig = false },
    fmt(
      [[
      @document.meta
      title: {}
      description: 
      authors: alex.tylor
      categories: journal
      created: {}
      updated: {}
      version: {}
      @end

      * Tasks
      {}

      * Planner

        - ( ) 0900 - 
        - ( ) 1000 - 
        - ( ) 1100 - 
        - ( ) 1200 - 
        - ( ) 1300 - 
        - ( ) 1400 - 
        - ( ) 1500 - 
        - ( ) 1600 - 
        - ( ) 1700 - 
        - ( ) 1800 - 

      * Notes
    ]],
      {
        i(1, "Title"),
        f(get_timestamp, {}),
        f(get_timestamp, {}),
        f(neorg_meta_version, {}),
        i(2, ""),
      }
    )
  ),

  s(
    { trig = "templateproject", descr = "Template for project", regTrig = false },
    fmt(
      [[
      @document.meta
      title: {}
      description: {}
      authors: alex.tylor
      categories: {}
      created: {}
      updated: {}
      version: {}
      @end

      {}

    ]],
      {
        i(1, "Title"),
        i(2, ""),
        i(3, ""),
        f(get_timestamp, {}),
        f(get_timestamp, {}),
        f(neorg_meta_version, {}),
        i(4, ""),
      }
    )
  ),

  s(
    { trig = "templateslipbox", descr = "Template for slipbox entry", regTrig = false },
    fmt(
      [[
      @document.meta
      title: {}
      description: {}
      authors: alex.tylor
      categories: {}
      created: {}
      updated: {}
      version: {}
      @end

      * Overview
      {}

      * Notes

      * Resources
    ]],
      {
        i(1, "Title"),
        i(2, ""),
        i(3, ""),
        f(get_timestamp, {}),
        f(get_timestamp, {}),
        f(neorg_meta_version, {}),
        i(4, ""),
      }
    )
  ),
}
