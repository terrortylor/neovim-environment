local plug = require("pluginman")

local c = require('config.colours').c
local hl = require('util.highlights')
local set_highlight = hl.set_highlight
local fg = hl.guifg
local bg = hl.guibg
local util = require('util.config')

local M = {}

function M.highlighting()
  set_highlight("Sneak", {fg(c.bg), bg(c.green1)})
  set_highlight("SneakLabel", {fg(c.bg), bg(c.green1)})
  set_highlight("SneakLabelMask", {fg(c.green1), bg(c.green1)})
  set_highlight("SneakScope", {fg(c.bg), bg(c.red1)})
end

function M.setup()
  plug.add({
    url = "justinmk/vim-sneak",
    post_handler = function()
      util.create_autogroups({
        sneak_highlights = {
          {"colorscheme", "*", "lua require('config.plugin.vim-sneak').highlighting()"}
        }
      })
    end
  })
end

return M
