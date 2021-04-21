local plug = require("pluginman")
local c = require('config.colours').c
local hl = require('util.highlights')
local set_highlight = hl.set_highlight
local fg = hl.guifg
local bg = hl.guibg
local lsp_funcs = require('config.lsp.funcs')
local util = require('util.config')

local M = {}

function M.highlighting()
  set_highlight("GitGutterAdd", fg(c.green2))
  set_highlight("GitGutterChange", fg(c.blue3))
  set_highlight("GitGutterDelete", fg(c.red2))
end

function M.setup()
  plug.add({
    url = "lewis6991/gitsigns.nvim",
    branch = "main",
    post_handler = function()
      require('gitsigns').setup {
        signs = {
          -- add          = {hl = 'GitGutterAdd'   , text = '+'},
          -- change       = {hl = 'GitGutterChange', text = '~'},
          -- delete       = {hl = 'GitGutterDelete', text = '_'},
          -- topdelete    = {hl = 'GitGutterDelete', text = '‾'},
          -- changedelete = {hl = 'GitGutterChange', text = '~'},
          add          = {hl = 'GitGutterAdd'   , text = '▍'},
          change       = {hl = 'GitGutterChange', text = '▍'},
          delete       = {hl = 'GitGutterDelete', text = '▂'},
          topdelete    = {hl = 'GitGutterDelete', text = '▔'},
          changedelete = {hl = 'GitGutterChange', text = '▐'},
        },
        numhl = false,
        keymaps = {
          -- Default keymap options
          noremap = true,
          buffer = true,

          ['n ]h'] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns\".next_hunk()<CR>'"},
          ['n [h'] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns\".prev_hunk()<CR>'"},

          ['n <leader>hs'] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
          ['n <leader>hu'] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
          ['n <leader>hr'] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
          ['n <leader>hp'] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',

          -- Text objects
          ['o ih'] = ':<C-U>lua require"gitsigns".text_object()<CR>',
          ['x ih'] = ':<C-U>lua require"gitsigns".text_object()<CR>'
        },
        watch_index = {
          interval = 1000
        },
        sign_priority = 1,
        status_formatter = nil, -- Use default
        -- TODO make this an option on plugin?
        util.create_autogroups({
          gitsigns_highlights = {
            {"colorscheme", "*", "lua require('config.plugin.gitsigns').highlighting()"}
          }
        })

      }
    end
  })
end

return M
