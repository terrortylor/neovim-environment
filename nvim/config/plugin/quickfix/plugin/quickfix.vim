" Todo camel case all variables rwview google code practice
if exists('g:loaded_quickfix_plugin')
  finish
endif
let g:loaded_quickfix_plugin = 1

" Opens a new tab with quickfix list open, selecting first item
command! TabbedQuicklistViewer call TabbedQuicklistViewer()
