local util = require('config.util')
local nresil = util.noremap_silent

util.create_keymap("n", "<leader>tt", ":<C-u>call NerdToggleFind()<CR>", nresil)

local autogroups = {
  nerdtree_auto_close_vim = {
	  {"BufEnter", "*", 'if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif'}
  },
}

util.create_autogroups(autogroups)

local global_variables = {
  NERDTreeShowHidden = 1,
  -- Close after opening a file/bookmark
  -- try to force me to use go/gi for preview
  NERDTreeQuitOnOpen = 3,
  -- Overwrite reuse behaviour so open in expected window not jump to window if
  -- already open
  NERDTreeCustomOpenArgs = {['file'] = {['reuse'] = '', ['where'] = 'p'}, ['dir'] = {}}
}

util.set_variables(global_variables)
