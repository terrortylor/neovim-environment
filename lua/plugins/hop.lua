local plug = require("pluginman")

local c = require('config.colours').c
local hl = require('util.highlights')
local set_highlight = hl.set_highlight
local fg = hl.guifg
local bg = hl.guibg

local M = {}

function M.setup()
  plug.add({
    url = "phaazon/hop.nvim",
    post_handler = function()
      require'hop'.setup {
        keys = 'etovxqpdygfblzhckisuran',
      }

      vim.api.nvim_set_keymap("n", "<leader>/", ":HopWord<CR>", {noremap = true, silent = true})
      -- TODO get visual seletions working

    end,
    highlight_handler = function()
      set_highlight("HopNextkey", {fg(c.yellow2), bg(c.blue5)})
      set_highlight("HopNextkey1", {fg(c.green1), bg(c.blue5)})
      set_highlight("HopNextkey2", {fg(c.green2), bg(c.blue5)})
    end
  })
end

return M
