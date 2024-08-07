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

local function get_human_timestamp()
  -- generate a ISO-8601 timestamp
  -- example: 2023-09-05T09:09:11-0500
  local tz_offset = get_timezone_offset()
  local h, m = math.modf(tz_offset / 3600)
  return os.date("%d %B %Y")
end

local function get_heading_date()
  return os.date("%A %B %Y (%d-%m-%Y) %H:%M")
end

local function neorg_meta_version()
  return require("neorg.core").config.norg_version
end

return {
  s(
    { trig = ";bqq", descr = "Markdown block quote", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmt("> {}", {
      d(1, get_visual),
    })
  ),

  s(
    {
      trig = ";bqw",
      descr = "Markdown block quote warning",
      regTrig = true,
      wordTrig = false,
      snippetType = "autosnippet",
    },
    fmt(
      [[
      >[!Warning]
      > {}
    ]],
      { d(1, get_visual) }
    )
  ),

  s(
    { trig = ";bb", descr = "Markdown bold text", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmt("**{}** ", {
      d(1, get_visual),
    })
  ),

  s(
    { trig = ";cc", descr = "Markdown code block", wordTrig = false, snippetType = "autosnippet" },
    fmt(
      [[
      ```{}
      {}
      ```
    ]],
      { i(1, "bash"), d(2, get_visual) }
    )
  ),

  s(
    { trig = ";ll", descr = "Markdown link", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmt("[<>](<>)", {
      d(1, get_visual),
      i(2, "description"),
    }, { delimiters = "<>" })
  ),

  s(
    { trig = ";ivaas" },
    fmt("[IVAAS-<>](https://orc-id.atlassian.net/browse/IVAAS-<>) ", {
      d(1, get_visual),
      rep(1),
    }, { delimiters = "<>" })
  ),

  s(
    { trig = ";inf" },
    fmt("[INF-<>](https://orc-id.atlassian.net/browse/INF-<>) ", {
      d(1, get_visual),
      rep(1),
    }, { delimiters = "<>" })
  ),
}
