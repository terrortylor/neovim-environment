local util = require('vim.lsp.util')

-- get line, find position of first non whitespace charecter
-- line passed in here requires -1 for some reason
local captures = vim.treesitter.get_captures_at_pos(13, 21, 4)
-- vim.pretty_print(captures)
print("Capture:", captures[1].capture)

-- eg:
-- neorg.headings.1.title
-- neorg.lists.unordered.1.prefix
--
-- if heading
--   if inc
--     add `*`
--   else dec
--     remove *
