" TODO remove cdo stuff feom peraonnal plugins
" tabbed quick fix viewer opens a new tab and then allows scrolling through
" the quick fix list whislt previewing a buffer window

" Opens a new tab with the quickfix list
" and selects the first item
function! quickfix#tabbed#TabbedQuicklistViewer() abort
  " echom "In function"
  if empty(getqflist())
    echo "No results to display"
  else
    " open a new tab
    tabnew
    " select first item in top pane
    cfirst
    " open quickfix list
    copen

    " Setup mappings, note this needs to run in the opened quickfix
    call s:setupMappings()

    " register macro to select next qf item
    " and run it so it's in the `@:` register
    " which is a hack to pre-populate the
    " read-only register `@:`
    " TODO this register shoyld be saved first and restored
    let @l=':call s:tabbedQuicklistNextItem()'
    normal @l
  endif
endfunction

function! s:setupMappings()
  " scrolling also selects entry then jumps back to quickfix
  nnoremap <buffer> j j<cr>:copen<CR>
  nnoremap <buffer> k k<cr>:copen<CR>
endfunction

" This calls `cn`, then checks if the current position
" is within a folded line, if so it expands the fold
" TODO rethink if this is actually required
function! s:tabbedQuicklistNextItem()
  cnext
  " if fold closed `-1` then expand
  if foldclosed(line('.')) > -1
    foldopen
    " TODO when switching the buffer should be checked if already exists and
    " if not then unload from buffer list so not to polute it
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
