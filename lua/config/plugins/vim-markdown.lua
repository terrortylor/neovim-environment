local plug = require("pluginman")

local M = {}

function M.setup()
  plug.add({
    url = "plasticboy/vim-markdown",
    post_handler = function()

      -- Don't require .md extension
      vim.g.vim_markdown_no_extensions_in_markdown = 1

      -- Autosave when following links
      vim.g.vim_markdown_autowrite = 1
    end
  })
end

return M
