if !exists('s:diff_options')
  " Note that diff_options should end with a space
  let s:diff_options = '-w '
endif

function! gittools#GitDiffFile()
  " Capture current file
  let a:current_file = expand("%")
  " and filetype
  let a:filetype = &filetype

  tabnew
  let a:git_diff_command = "git diff " . s:diff_options . a:current_file
  " let a:git_diff = split(system(a:git_diff_command))
  let a:git_diff = systemlist(a:git_diff_command)
  call append(0, a:git_diff)

  " Set some additional syntax to mark diff addition/removal etc
  " reuse filetype=git highlight group names but limit match to begining of
  " the line
  highlight diffAdded ctermbg=DarkGreen guibg=#7EE081 ctermfg=black guifg=#00000
  highlight diffRemoved ctermbg=DarkRed guibg=#DD9787 ctermfg=black guifg=#000000
  highlight diffSection ctermbg=Blue guibg=#258EA6 ctermfg=black guifg=#000000
  call matchadd('diffAdded', '^+', 11)
  call matchadd('diffRemoved', '^-', 11)
  call matchadd('diffSection', '^@@.*@@', 11)

  " Set filetype to selected buffers for some syntax rather then set filetype
  " to git
  execute('set filetype=' . a:filetype)

  " Make the new window blank/scratch and nonmodifiable
  setlocal buftype=nofile bufhidden=wipe nomodifiable nobuflisted noswapfile
    \ nonumber norelativenumber
    \ nocursorline nocursorcolumn winfixwidth winfixheight
    \ statusline=\
endfunction

function! gittools#GitLogTree()
  tabnew
  let a:git_log_command= "git log --pretty=format:'%h %s [%ad %cn]' --decorate --date=short --graph --all"
  let a:git_diff = systemlist(a:git_log_command)
  call append(0, a:git_diff)

  " Set filetype to selected buffers for some syntax rather then set filetype
  " to vim-git-tools
  execute('set filetype=vim-git-tools')

  call gittools#SetNonEditWindow()
  call gittools#GitLogSyntax()
endfunction

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
  syntax match myDate "\[\d\{4}-\d\{2}-\d\{2} \S\+\]" contained

  highlight link myFileAsterisk Number
  highlight link myFileHash     Statement
  highlight link myFullLine     String
  highlight link myDate         Delimiter
endfunction

" command! GitDiffFile call GitDiffFile()
" command! GitLogTree call GitLogTree()
