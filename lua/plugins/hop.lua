local plug = require("pluginman")

local c = require('config.colours').c
local hl = require('util.highlights')
local set_highlight = hl.set_highlight
local fg = hl.guifg
local bg = hl.guibg
local util = require('util.config')

local M = {}

function M.highlighting()
  set_highlight("HopNextkey", {fg(c.yellow2), bg(c.blue5)})
  set_highlight("HopNextkey1", {fg(c.green1), bg(c.blue5)})
  set_highlight("HopNextkey2", {fg(c.green2), bg(c.blue5)})
end

function M.setup()
  plug.add({
    url = "phaazon/hop.nvim",
    post_handler = function()
      require'hop'.setup {
        keys = 'etovxqpdygfblzhckisuran',
      }

      vim.api.nvim_set_keymap("n", "<leader>/", ":HopWord<CR>", {noremap = true, silent = true})
      -- TODO get visual seletions working

      util.create_autogroups({
        hop_highlights = {
          {"colorscheme", "*", "lua require('plugins.hop').highlighting()"}
        }
      })
    end
  })
end

return M
