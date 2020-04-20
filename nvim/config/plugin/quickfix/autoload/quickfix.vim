" TODO remove cdo stuff feom peraonnal plugins
" tabbed quick fix viewer opens a new tab and then allows scrolling through
" the quick fix list whislt previewing a buffer window

" Opens a new tab with the quickfix list
" and selects the first item
function! TabbedQuicklistViewer() abort
  " echom "In function"
  if empty(getqflist())
    echo "No results to display"
  else
    " open a new tab
    tabnew
    " open quickfix list
    copen

    call SetupMappings()

    " register macro to select next qf item
    " and run it so it's in the `@:` register
    " which is a hack to pre-populate the
    " read-only register `@:`
    " TODO this register shoyld be saved first and restored
    let @l=':call TabbedQuicklistNextItem()'
    normal @l
    " select first item in top pane
    cfirst
  endif
endfunction

function! SetupMappings()
  " scrolling also selects buffer
  nnoremap <buffer> j j<cr><c-w>j
  nnoremap <buffer> k k<cr><c-w>j
endfunction

" This calls `cn`, then checks if the current position
" is within a folded line, if so it expands the fold
function! TabbedQuicklistNextItem()
  cnext
  " if fold closed `-1` then expand
  if foldclosed(line('.')) > -1
    foldopen
    " TODO when switching the buffer should be checked if wxista and unloaded
    " if it didnt so buf list doeant get full
    " TODO add maping to leave in buffer list and to clear and populate arg
    " list
    " wincmd t
  endif

  " if buffer has changed then select top-left split
  let thisbuf = bufnr("%")
  let lastwin = winnr("#")
  let lastbuf = winbufnr(lastwin)
  if thisbuf != lastbuf
    wincmd t
  endif
endfunction
