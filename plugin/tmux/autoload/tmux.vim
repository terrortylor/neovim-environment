" Stores tmux pane in current window to send command too
if !exists('s:tmux_send_to_pane')
  let s:tmux_send_to_pane = ''
endif

" Stores the command to send
if !exists('s:tmux_send_to_command')
  let s:tmux_send_to_command = ''
endif

function! tmux#CapturePaneNumber() abort
  call system("tmux display-panes")
  let s:tmux_send_to_pane = input('Enter pane to send too: ')
  " hack to clear command input
  redraw
endfunction

" Used to set the command to send via user input
" The current command is used as a default value, so the function can also be
" used to edit an existing command
function! tmux#SetCommandFromUserInput() abort
  let s:tmux_send_to_command = input('Enter command to send: ', exists('s:tmux_send_to_command') ? s:tmux_send_to_command : '')
endfunction

function! tmux#SendCommandToPane() abort
  if empty(s:tmux_send_to_pane)
    call tmux#CapturePaneNumber()
  endif

  if empty(s:tmux_send_to_command)
    call tmux#SetCommandFromUserInput()
  endif

  if  g:tmux_save_first == v:true
    wa
  endif

  if empty(s:tmux_send_to_pane) || empty(s:tmux_send_to_command)
    echom "Missing pane or command, not running"
    return
  endif

  call system('tmux send-keys -t "' . s:tmux_send_to_pane . '" C-z "' . s:tmux_send_to_command . '" Enter')
endfunction
