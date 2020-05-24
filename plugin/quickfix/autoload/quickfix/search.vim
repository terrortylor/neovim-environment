" Runs search in sub shell, shows results in tabbed view with some additional
" mappings
function! quickfix#search#TabbedGrep(...) abort
  call call('s:run_search', a:000)
  call quickfix#tabbed#TabbedQuicklistViewer()
endfunction

" Runs search in sub shell, and displays results in quickfix window
" silent result (i.e.  no press enter prompt) and does not show first match in
" current window
function! quickfix#search#SimpleGrep(...) abort
  call call('s:run_search', a:000)
  if len(getqflist()) == 0
    echom 'No matches found'
  else
    copen
  endif
endfunction

function! s:run_search(...) abort
  " call is used here to pass on the varagrs
  " let l:command = call('s:build_ack_command', a:000)
  " let l:command = call('s:build_grep_command', a:000)
  let l:command = call('s:build_external_search_command', a:000)

  " Set error format to NOT have a space after the column and before the
  " message
  let l:errorformat = &errorformat
  execute('let &errorformat="' . g:quickfix_search_binaries_errorformat . '"')

  " run the query as a sub process
  cgetexpr system(l:command)

  " restore errorformat
  let &errorformat = l:errorformat
endfunction

" Returns the search command to use, it uses values from a global map and the
" system's 'ignorecase' value to manage switching on and off case sensativity
function! s:build_external_search_command(...) abort
  let l:binary_config = get(g:quickfix_search_binaries, g:quickfix_external_binary)
  let l:command = get(l:binary_config, 'bin')
  let l:command .= ' ' . get(l:binary_config, 'default_options')

  if &ignorecase
    let l:command .= ' ' . get(l:binary_config, 'case_insensitive')
  endif

  if a:0 == 1
    " NOTE: ack doesn't require this but doesn't hurt so easier to have single
    " rule for both tools
    let l:command .= ' ' . join(a:000, ' ') . ' *'
  else
    let l:command .= ' ' . join(a:000, ' ')
  endif

  return l:command
endfunction
