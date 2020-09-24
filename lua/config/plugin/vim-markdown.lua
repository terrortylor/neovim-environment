local util = require('util.config')

local global_variables = {
  -- Don't require .md extension
  vim_markdown_no_extensions_in_markdown = 1,

  -- Autosave when following links
  vim_markdown_autowrite = 1


}

util.set_variables(global_variables)
