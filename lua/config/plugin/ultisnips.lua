local util = require('util.config')

local global_variables = {
  ["UltiSnipsExpandTrigger"]       = "<tab>",
  ["UltiSnipsEditSplit"]           = "vertical",
  -- TODO c-u isn't a great mapping as overrides builtin
  ["UltiSnipsListSnippets"]        = "<c-u>",
  ["UltiSnipsJumpForwardTrigger"]  = '<tab>',
  ["UltiSnipsJumpBackwardTrigger"] = '<s-tab>',
  ["UltiSnipsSnippetsDir"]         = "/home/alextylor/.config/nvim/ultisnips",
}

util.set_variables(global_variables)
