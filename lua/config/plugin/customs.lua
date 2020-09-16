local util = require('config.util')
local nresil = util.noremap_silent

-- Send to TMUX
util.create_keymap("n", "<leader>nn", ":lua require('tmux.send_command').send_command_to_pane()<CR>", nresil)

-- Open alternate file (test file)
util.create_keymap("n", "<leader>ga", ":<C-u>lua require('alternate').get_alternate_file()<CR>", nresil)
