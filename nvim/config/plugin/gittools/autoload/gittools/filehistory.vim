" Used to explore versions of a file
function! gittools#filehistory#GitFileHistoryExplore() abort
  " Capture current file
  let s:git_history_file = expand("%")
  " and filetype
  let s:git_history_filetype = &filetype

  " Setup tab layout, start with log tree as already handles new tab
  call gittools#GitLogTree()
  let a:tree_win_id = win_getid()
  " add mapping to Log Tree window
  " TODO this mapping should only be on window
  nnoremap <Space> :call gittools#filehistory#UpdateRemoteWindow()<CR>
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
	let a:pattern   = '\v*\s+(\w{7})'
	let a:line = getline('.')
	let a:matched   = matchlist(a:line, a:pattern)
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
  call gittools#filehistory#GitShow(s:git_history_file, a:matched[1], s:git_history_filetype)
  setlocal nomodifiable

  call win_gotoid(t:filediff_windows.log)
endfunction

function! gittools#filehistory#SetupDiffWindow(command, filetype) abort
  execute a:command
  execute('set filetype=' . a:filetype)
  call gittools#SetNonEditWindow()
  " Setup diff on windows
  diffthis
  " return the window id for resizing later
  return win_getid()
endfunction

function! gittools#filehistory#GitShow(filepath, revision, filetype) abort
  let a:git_show_command = "git show " . a:revision . ":" . a:filepath
  let a:git_show = systemlist(a:git_show_command)
  call append(0, a:git_show)

  " go to top of file
  execute "0"

  " TODO this isn't required as already being set
  " " Set filetype to selected buffers for some syntax rather then set filetype
  " " to git
  " execute('set filetype=' . a:filetype)
  " call gittools#SetNonEditWindow()
endfunction
