" Displays a popup that waits until next keypress before closing
"
" Arguments:
"   lines: List of strings to display in alert
"   on_cursor: Controlls weather the floating window is on the same line as
"   cursor or under it
function! helper#float#info(lines, on_cursor) abort
  " work out max width
  let l:max_line_length = 0
  for l in a:lines
    if len(l) > l:max_line_length
      let l:max_line_length = len(l)
    endif
  endfor

  " create scratch buffer from lines and create floating window
  let l:buf = nvim_create_buf(v:false, v:true)
  call nvim_buf_set_lines(buf, 0, -1, v:true, a:lines)
  " TODO opts may need to be injected!?!?!?
  " TODO the row value here is wrong for a range, as displays from cursor
  " which is liekly the last not the first row
  let l:opts = {'relative': 'cursor', 'width': l:max_line_length, 'height': len(a:lines), 'col': 0,
        \ 'row': a:on_cursor ? 0 : 1, 'anchor': 'NW', 'style': 'minimal'}
  let l:win = nvim_open_win(l:buf, v:false, l:opts)
  " TODO add styling
  " TODO add window / buffer options line filetype for syntax

  " force redraw before getchar so float is displayed
  redraw

  " Sort of hacky but catch next key and close window
  try
    let l:char = getchar()
  endtry
  call nvim_win_close(l:win, v:true)
endfunction

" Displays a terminal in a centered popup window. The passed `cmd` runs and
" once it finishes the terminal is destroyed.
"
" Arguments:
"   cmd: command to run
function! helper#float#SingleUseTerminal(cmd) abort
  if a:cmd ==# ''
    return
  endif
  let l:buf = nvim_create_buf(v:false, v:true)

  let l:x_padding = 4
  let l:y_padding = 2

  let l:width = &columns - (l:x_padding * 2)
  let l:height = &lines - (l:y_padding * 4)
  let l:opts = {'relative': 'win', 'width': l:width, 'height': l:height, 'col': l:x_padding, 'row': l:y_padding, 'anchor': 'NW', 'style': 'minimal'}
  let l:win = nvim_open_win(l:buf, v:true, l:opts)

  call termopen(a:cmd, { 'on_exit': function('helper#float#TermExitCallBack') })
  " Enter insert mode
  " TODO if autocommand used to enter insert mode on terminal then this may
  " need to be rethinked
  normal! i
endfunction

" Used by the function 'helper#float#SingleUseTerminal' to simply call
" bwipeout once the passed command exists
function! helper#float#TermExitCallBack(job_id, code, event) abort
  if a:code == 0
    bwipeout!
  endif
endfunction
