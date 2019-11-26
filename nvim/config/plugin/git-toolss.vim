let s:cpo_save = &cpo
set cpo&vim

function! GitDiffFile()
  " Capture current file
  let a:current_file = expand("%")
  " and filetype
  let a:filetype = &filetype

  tabnew
  let a:git_diff_command = "git diff " . a:current_file
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

let &cpo = s:cpo_save
unlet s:cpo_save

command! GitDiffFile call GitDiffFile()
