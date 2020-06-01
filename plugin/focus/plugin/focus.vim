if exists('g:loaded_focus_plugin')
  finish
endif
let g:loaded_focus_plugin = 1

command! FocusBuffer call FocusBuffer()
