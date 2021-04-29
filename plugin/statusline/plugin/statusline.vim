if exists('g:loaded_statusline_plugin')
  finish
endif
let g:loaded_statusline_plugin = 1

" This will only show the filename in inactive windows
if !exists('g:statusline_show_inactive')
  let g:statusline_show_inactive = v:true
endif

if !exists('g:statusline_show_git_branch')
  let g:statusline_show_git_branch = v:false
endif

if !exists('g:statusline_show_mode')
  let g:statusline_show_mode = v:false
endif

augroup old_statusline_update
  autocmd!
  " autocmd VimEnter,WinEnter,BufWinEnter * call statusline#update()
augroup END
