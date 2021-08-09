local M = {}

function M.setup()
      require('gitsigns').setup {
        signs = {
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
          -- TODO check these are working
          ['o ih'] = ':<C-U>lua require"gitsigns".text_object()<CR>',
          ['x ih'] = ':<C-U>lua require"gitsigns".text_object()<CR>'
        },
        watch_index = {
          interval = 1000
        },
        -- sign_priority = 15,
        status_formatter = nil, -- Use default
      }
end

return M
