" Closes any quickfix window in current tab
" This includes location list
function! quickfix#window#CloseAll() abort
  let l:tabnr = tabpagenr()
  for w in getwininfo()
    if w.tabnr == l:tabnr
      if w.quickfix == 1
        call nvim_win_close(w.winid, v:false)
      endif
    endif
  endfor
endfunction

" Opens up current windows location list if not empty, otherwise the quickfix
" if not empty.  If both are empty then just display message.
function! quickfix#window#OpenList() abort
  if len(getloclist(winnr())) > 0
    lopen
  else
    if len(getqflist()) > 0
      copen
    else
      echo 'All lists are empty'
    endif
  endif
endfunction
