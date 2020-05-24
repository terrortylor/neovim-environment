" Wrapper to jobsend
" takes multi-lines as a list and boolean on weather to send <CR>
function! s:RunCommandsInTerminal(job_id, lines, exec) abort
  if a:job_id <= 0
    echom "job_id invalid, exiting"
    return
  endif
  if a:exec
    call add(a:lines, "\n")
  endif
  call jobsend(a:job_id, a:lines)
endfunction

function! ToggleTerminal(terminal_buffer_name) abort
  " Get current window id in case terminal window exists
  let l:current_win_id = win_getid()

  " get terminal window id
  let l:terminal_window_id = s:GetTerminalBufferWindowID(a:terminal_buffer_name)
  " if exists, jump to it, close and jump back
  " TODO Check that more than one window open before closing
  if l:terminal_window_id == 0
    execute 'split ' . a:terminal_buffer_name
  elseif l:terminal_window_id > 0
    call win_gotoid(l:terminal_window_id)
    close
  endif

  call win_gotoid(l:current_win_id)
endfunction

" This returns the window ID of a given named terminal
" Returns -1 if buffer doesn't exist
" Returns 0 if not open in window
function! s:GetTerminalBufferWindowID(terminal_buffer_name) abort
  let l:window_id = 0

  " Check if buffer exists
  let l:repl_buffer_number = bufnr(a:terminal_buffer_name)
  if l:repl_buffer_number == -1
    return l:repl_buffer_number
  end

  if l:repl_buffer_number > 0
    " Check if buffer open in a window
    let l:repl_buffer_window_number = bufwinnr(l:repl_buffer_number)

    if l:repl_buffer_window_number > 0
      let l:window_id = win_getid(l:repl_buffer_window_number)
    endif
  endif

  return l:window_id
endfunction

" Opens a terminal, if doesn't already exist, and sets the buffer name as
" supplied
" returns the named buffers 'terminal' job_id to pass commands/lines too
function! s:OpenTerminal(terminal_buffer_name) abort
  " capture current window id
  let l:current_win_id = win_getid()

  " set term_job_id as 0
  let l:terminal_job_id = 0

  " Check if buffer or window exist
  let l:terminal_window_id = s:GetTerminalBufferWindowID(a:terminal_buffer_name)

  if l:terminal_window_id == -1
    " Terminal buffer doesn't exists
    " Create buffer in split
    split term://bash
    let l:terminal_job_id = b:terminal_job_id
    file REPL " Give the buffer a name
  elseif l:terminal_window_id > 0
    call win_gotoid(l:terminal_window_id)
    let l:terminal_job_id = b:terminal_job_id
  else
    " window doesn't exist so split and capture job_id
    execute 'split ' . a:terminal_buffer_name
    let l:terminal_job_id = b:terminal_job_id
  endif

  " leave focus back on orig window
  call win_gotoid(l:current_win_id)

  return l:terminal_job_id
endfunction

function! RunFileInTerminal() abort
  let l:file_path = expand('%:p')
  let l:file_name = @%

  " if scratch then need to create temporary file
  if expand('%') ==# 'scratch'
    execute 'w! /tmp/scratch.' . &filetype
    let l:file_path = '/tmp/scratch.' . &filetype
    let l:file_name .= '.' . &filetype
    echo 'written /tmp/scratch'
  endif

  if &filetype ==# 'kotlin'
    let l:repl_command = [g:repl_compile . ' ' . l:file_path . ' -include-runtime -d /tmp/' . l:file_name . '.jar && ' . g:repl_run . ' -jar /tmp/' . l:file_name . '.jar']
  elseif &filetype ==# 'sh'
    let l:repl_command = [g:repl_run . ' ' . l:file_path]
  elseif &filetype ==# 'go'
    let l:repl_command = [g:repl_run . ' ' . l:file_path]
  else
    echo 'Unsupported FileType'
    return
  endif

  let l:term_id = s:OpenTerminal('REPL')

  sleep 100m " Hack to prevent it looking like input has been sent twice
  call s:RunCommandsInTerminal(l:term_id, l:repl_command, v:true)
endfunction
