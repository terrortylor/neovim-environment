" echom's each item in a list, if more than a list is passed in then it uses
" the helper#echom#debug function to prefix line with 'DEBUG: '
function! helper#echom#list(list, ...) abort
  for i in a:list
    if a:0 > 0
      call helper#echom#debug(i)
    else
      echom i
    endif
  endfor
endfunction

function! helper#echom#map(map, ...) abort
  for [k, v] in items(a:map)
    if a:0 > 0
      call helper#echom#debug(k . ' : ' . v)
    else
      echom k . ' ' . v
    endif
  endfor
endfunction

" wrapper for echom so that message is prefixed with: DEBUG:
function! helper#echom#debug(message) abort
 echom 'DEBUG: ' . a:message
endfunction
