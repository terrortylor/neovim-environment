" Displays a floating window over current line(s) with git blame information.
" Output: hash author date
" Input: accepts a range
function! gittools#GitBlameFloat() range
  let output = system('git blame -L ' . a:firstline . ',' . a:lastline .' ' . expand('%'))
  let lines = split(output, '\n')

  " lines have too much info, so trim
  " h45h the/file/name.vim (Author Name   2020-05-11 20:33:19 +0100 2)   The actual line
  "
  " only want to show:
  " h45h Author Name 2020-05-11 20:33:19
  let l:modified_lines = []
  for l in lines
    " TODO doesn't take into account line not exist in git
    " 00000000 (Not Committed Yet 2020-05-25 21:26:21 +0100 6) function! gittools#FloatGitBlame() range
    let l:modified_lines = add(l:modified_lines, substitute(l, '\v^(\S+)\s\S+\s\((.*)\s\+\d+\s\d+\).*', '\1 \2', ''))
  endfor
  call helper#float#info(l:modified_lines, v:true)
endfunction

" Calls 'git log' in a 'pretty' format and displays in a new tab, with basix
" syntax
function! gittools#GitLogPretty()
  tabnew
  let l:git_log_command= "git log --pretty=format:'%h %s [%ad %cn]' --decorate --date=short --graph --all"
  " TODO look for where i'm calling split(system and replace with systemlist
  let l:git_diff = systemlist(l:git_log_command)
  call append(0, l:git_diff)

  " Set filetype to selected buffers for some syntax rather then set filetype
  " to vim-git-tools
  execute('set filetype=vim-git-tools')

  call gittools#SetNonEditWindow()
  " TODO Highlighting could be really improved
  call gittools#GitLogSyntax()
  normal! gg
endfunction

" TODO move to helper function?
function! gittools#SetNonEditWindow() abort
    " Make the new window blank/scratch and nonmodifiable
     setlocal buftype=nofile
     setlocal bufhidden=wipe
     setlocal nomodifiable
     setlocal nobuflisted
     setlocal noswapfile
     setlocal nonumber
     setlocal norelativenumber
     setlocal nocursorline
     setlocal nocursorcolumn
     setlocal nospell
endfunction

function! gittools#GitLogSyntax() abort
  syntax match myFullLine "^\*.*$" contains=myFileAsterisk,myFileHash,myDate
  syntax match myFileAsterisk "*\s" contained
  syntax match myFileHash "^\*\s\w\{7}" contained contains=myFileAsterisk
  syntax match myDate "\[\d\{4}-\d\{2}-\d\{2} .\{-}\]" contained

  highlight link myFileAsterisk Number
  highlight link myFileHash     Statement
  highlight link myFullLine     String
  highlight link myDate         Delimiter
endfunction
