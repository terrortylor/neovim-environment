" Calls 'git diff' on the current buffer in a new tab, it then applies the
" filetype's syntax highlighting to the buffer to make it easier to read
function! gittools#gitdiff#WithSyntax() abort
  " Capture current file
  let l:current_file = expand("%")
  " and filetype
  let l:filetype = &filetype

  tabnew
  let l:git_diff_command = "git diff " . g:diff_options . l:current_file
  let l:git_diff = systemlist(l:git_diff_command)
  call append(0, l:git_diff)

  " Set some additional syntax to mark diff addition/removal etc
  " reuse filetype=git highlight group names but limit match to begining of
  " the line
  " TODO extract all highlighting and make it easier to override
  highlight diffAdded ctermbg=DarkGreen guibg=#7EE081 ctermfg=black guifg=#00000
  highlight diffRemoved ctermbg=DarkRed guibg=#DD9787 ctermfg=black guifg=#000000
  highlight diffSection ctermbg=Blue guibg=#258EA6 ctermfg=black guifg=#000000
  call matchadd('diffAdded', '^+', 11)
  call matchadd('diffRemoved', '^-', 11)
  call matchadd('diffSection', '^@@.*@@', 11)

  " Set filetype to selected buffers for some syntax rather then set filetype
  " to git
  execute('set filetype=' . l:filetype)

  " Make the new window blank/scratch and nonmodifiable
  setlocal buftype=nofile bufhidden=wipe nomodifiable nobuflisted noswapfile
    \ nonumber norelativenumber
    \ nocursorline nocursorcolumn winfixwidth winfixheight
    \ statusline=\
endfunction
