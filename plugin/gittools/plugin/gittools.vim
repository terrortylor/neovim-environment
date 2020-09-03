if exists('g:loaded_gittools_plugin')
  finish
endif
let g:loaded_gittools_plugin = 1
if !exists('g:diff_options')
  " Note that diff_options should end with a space
  let g:diff_options = '-w '
endif

" Calls 'git diff' on the current buffer in a new tab, it then applies the
" filetype's syntax highlighting to the buffer to make it easier to read
command! GitDiffFileWithSyntax call gittools#gitdiff#WithSyntax()
command! GitLogPretty call gittools#GitLogPretty()
command! GitFileHistoryExplore call gittools#filehistory#GitFileHistoryExplore()
" Displays git blame info in a floating window
" command! -nargs=0 -range GitBlameFloat :<line1>,<line2>call gittools#GitBlameFloat()

" Create internal mappings to be mapped as required
" TODO feel like there is a better way
nnoremap <Plug>(FloatGitBlame) :.call gittools#FloatGitBlame()
vnoremap <Plug>(FloatGitBlame) :'<,'>call gittools#FloatGitBlame()
