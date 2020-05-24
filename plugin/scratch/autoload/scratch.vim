  " Opens a scratch buffer window
  " If no buffer exists then create window and buffer
  " If buffer and window exist then move to it
  " If buffer exist but not in window then open in split
  function! Scratch()
    " if scratch buffer exists
    if bufnr(g:scratch_buffer_name) > 0
      " buffer exists check to see if window exists
      let scratch_window_name = bufwinnr(g:scratch_buffer_name)
      if scratch_window_name > 0
        execute scratch_window_name . 'wincmd w'
      else
        " open in split
        execute 'vsplit' g:scratch_buffer_name
      endif
    else
      " otherwise open new split as setup
      split
      noswapfile hide enew
      setlocal buftype=nofile
      setlocal bufhidden=hide
      execute 'file' g:scratch_buffer_name
    endif
  endfunction

  " If a scratch buffer exists then paste from the +
  " register
  function! PasteToScratch()
    " capture current and scratch buffers
    let current_buffer = bufnr('%')
    let scratch_buffer = bufnr(g:scratch_buffer_name)
    if scratch_buffer > 0
      " move to scratch buffer if not already in it
      " as moving to same window sporks
      if current_buffer != scratch_buffer
        call Scratch()
      endif
      " at end of file add new line and then reg contents
      call append(line('$'), '')
      call append(line('$'), getreg(g:scratch_paste_register))
      if current_buffer != scratch_buffer
        execute current_buffer . 'wincmd w'
      endif
    else
      echom "No scratch file found"
    endif
  endfunction

