local plug = require("pluginman")

local M = {}

function M.setup()
  plug.add({
  url = "takac/vim-hardtime",
    post_handler = function()
      vim.g.hardtime_default_on = 1
    end
  })
end

return M
