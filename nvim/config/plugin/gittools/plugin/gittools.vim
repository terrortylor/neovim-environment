if exists('g:loaded_gittools_plugin')
  finish
endif
let g:loaded_gittools_plugin = 1

command! GitDiffFile call gittools#GitDiffFile()
command! GitLogTree call gittools#GitLogTree()
command! GitFileHistoryExplore call gittools#filehistory#GitFileHistoryExplore()
