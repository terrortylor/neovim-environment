local plug = require("pluginman")

local M = {}

function M.setup()
  plug.add({
  url = "takac/vim-hardtime",
    post_handler = function()
      vim.api.nvim_command("let g:hardtime_default_on = 1")
    end
  })
end

return M
