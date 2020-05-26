" Used to explore versions of a file from different commits, opens a new tab
" with 'git log' on far left, historic file in middle and current state on far right.
function! gittools#filehistory#GitFileHistoryExplore() abort
  " Capture current file
  let s:git_history_file = expand("%")
  " and filetype
  let s:git_history_filetype = &filetype

  " Setup tab layout, start with log tree as already handles new tab
  call gittools#GitLogPretty()
  " add mapping to Log Tree window to update historic buffer
  " TODO LHS of mapping should be configurable
  nnoremap <buffer> <Space><Space> :call gittools#filehistory#UpdateRemoteWindow()<CR>
  let t:filediff_windows = {}
  let t:filediff_windows.log = win_getid()
  let t:filediff_windows.remote = gittools#filehistory#SetupDiffWindow('vertical botright new', s:git_history_filetype)
  let t:filediff_windows.local = gittools#filehistory#SetupDiffWindow('vertical botright new ' . s:git_history_file, s:git_history_filetype)

  " Move to top of tree window
  call win_gotoid(t:filediff_windows.log)
  execute "0"
  call gittools#filehistory#UpdateRemoteWindow()
endfunction

function! gittools#filehistory#UpdateRemoteWindow() abort
  " TODO make very magic
	let l:pattern   = '\v*\s+(\w{7})'
	let l:line = getline('.')
	let l:matched   = matchlist(l:line, l:pattern)
  " TODO
	" let a:pattern   = '\v\*\s+(\w{7})'
  " add check to ensure matched has items
  " then check to see if [1] exists
  " then move to remote window and call gittools#GitShow
  " moving back to tree
  call win_gotoid(t:filediff_windows.remote)
  setlocal modifiable
  " Clear buffer
  execute "normal ggdG"
  call gittools#filehistory#GitShow(s:git_history_file, l:matched[1], s:git_history_filetype)
  setlocal nomodifiable

  call win_gotoid(t:filediff_windows.log)
endfunction

function! gittools#filehistory#SetupDiffWindow(command, filetype) abort
  execute a:command
  execute('set filetype=' . a:filetype)
 " TODO values set here are not being cleared after explorer tab view
 " close/lost focus
  call gittools#SetNonEditWindow()
  " Setup diff on windows
  diffthis
  " return the window id for resizing later
  return win_getid()
endfunction

function! gittools#filehistory#GitShow(filepath, revision, filetype) abort
  let l:git_show_command = "git show " . a:revision . ":" . a:filepath
  let l:git_show = systemlist(l:git_show_command)
  call append(0, l:git_show)

  " go to top of file
  execute "0"
endfunction
