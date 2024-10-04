-- If error later in scripts then this may/may not be set,
-- this is a crued way to guard around that
-- api.nvim_buf_set_option(0, "undofile", true)
-- viml set option sets global and local: https://github.com/nanotee/nvim-lua-guide#using-meta-accessors
vim.o.undofile = true
vim.bo.undofile = true

vim.g.mapleader = " "

-- require("config.plugins")
require("config.lazyplugins")

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    require("util.globals")

    -- Configurations
    require("config.options")
    require("config.autogroups")
    require("config.mappings")
    require("config.commands")
    require("config.abbreviations")

    -- Custom Plugins
    local plugins = {
      "git.blame",
      "ui.arglist",
      -- "ui.tabline",
      -- "ui.statusline",
      "ui.buffer.trailing_whitespace",
      "ui.window.numbering",
      -- "ui.search",
      -- "ui.splash",
      "tmux",
      "alternate",
      "ui.switcheroo",
      "pa",
      "snake",
      "util.auto_update",
    }

    for _, p in pairs(plugins) do
      require(p).setup()
    end
  end,
})
