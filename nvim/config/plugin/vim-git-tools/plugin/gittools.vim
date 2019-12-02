let s:cpo_save = &cpo
set cpo&vim

command! GitDiffFile call gittools#GitDiffFile()
command! GitLogTree call gittools#GitLogTree()
command! GitFileHistoryExplore call gittools#filehistory#GitFileHistoryExplore()

let &cpo = s:cpo_save
unlet s:cpo_save
