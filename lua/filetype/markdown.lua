local util = require('util.config')

require('markdown.todo').setup()

local win_options = {
  -- Selling
  spell          = true,

  -- Don't conceal
  conceallevel   = 0
}

util.set_win_options(win_options)
