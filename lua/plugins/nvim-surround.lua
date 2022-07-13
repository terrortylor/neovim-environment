require("nvim-surround").setup({
  keymaps = { -- vim-surround style keymaps
  insert = "ys",
  insert_line = "yss",
  visual = "S",
  delete = "ds",
  change = "cs",
},
delimiters = {
  pairs = {
    [")"] = { "( ", " )" },
    ["("] = { "(", ")" },
    ["}"] = { "{ ", " }" },
    ["{"] = { "{", "}" },
    [">"] = { "< ", " >" },
    ["<"] = { "<", ">" },
    ["]"] = { "[ ", " ]" },
    ["["] = { "[", "]" },
    ["*"] = { "*", "*" },
    ["/"] = { "/", "/" },
    ["-"] = { "-", "-" },
    ["_"] = { "_", "_" },
    ["|"] = { "|", "|" },
    ["^"] = { "^", "^" },
    ["$"] = { "$", "$" },
    ["="] = { "=", "=" },
    ["+"] = { "+", "+" },
    -- Define pairs based on function evaluations!
    ["i"] = function()
      return {
        require("nvim-surround.utils").get_input(
        "Enter the left delimiter: "
        ),
        require("nvim-surround.utils").get_input(
        "Enter the right delimiter: "
        )
      }
    end,
    ["f"] = function()
      return {
        require("nvim-surround.utils").get_input(
        "Enter the function name: "
        ) .. "(",
        ")"
      }
    end,
  },
  separators = {
    ["'"] = { "'", "'" },
    ['"'] = { '"', '"' },
    ["`"] = { "`", "`" },
  },
  HTML = { -- Disables HTML-style mappings
  ["t"] = "type", -- Change just the tag type
  ["T"] = "whole", -- Change the whole tag contents
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
      },
      highlight_motion = { -- Highlight before inserting/changing surrounds
      duration = 0,
    }
  })