local plug = require("pluginman")

-- Used for testing, has luasert embeded and doesn't require luarocks
-- TODO these should only be loaded if file ends in _spec.lua
-- but requires getting running `PlenaryBustedDirectory` working first with minimal `.vim` file
plug.add("nvim-lua/plenary.nvim")

-- Uses conceal to get terminal colours, used by plenary.nvim
plug.add({
  url = "norcalli/nvim-terminal.lua",
  post_handler = function()
    require'terminal'.setup()
  end
})
