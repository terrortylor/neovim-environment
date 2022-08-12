require("nvim-surround").setup({
  surrounds = {
    [")"] = {
      add = { "( ", " )" },
    },
    ["("] = {
      add = { "(", ")" },
    },
    ["}"] = {
      add = { "{ ", " }" },
    },
    ["{"] = {
      add = { "{", "}" },
    },
    [">"] = {
      add = { "< ", " >" },
    },
    ["<"] = {
      add = { "<", ">" },
    },
    ["]"] = {
      add = { "[ ", " ]" },
    },
    ["["] = {
      add = { "[", "]" },
    },
  },
  aliases = {
    ["a"] = "<", -- Single character aliases apply everywhere
    ["b"] = "(",
    ["B"] = "{",
    ["r"] = "[",
    -- Table aliases only apply for changes/deletions
    ["q"] = { '"', "'", "`" }, -- Any quote character
    ["s"] = { ")", "]", "}", ">", "'", '"', "`" }, -- Any surrounding delimiter
  },
})
