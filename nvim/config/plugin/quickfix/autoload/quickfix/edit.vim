" Marks a quickfix / location list as modifiable
function! quickfix#edit#SetModifiable() abort
  if s:IsQuickfixOrLocationList()
    set modifiable

    execute('setlocal errorformat=' . g:quickfix_local_errorformat)

    " Prompt to reload quickfix from buffer as underlying map and buffer lines
    " no longer match
    nnoremap <buffer> <cr> :echo 'Reload quickfix from buffer!'<cr>
  else
    echom "Not a quickfix/locationlist"
  endif
endfunction

" Reloads the quickfix / location list edited buffer
function! quickfix#edit#QuickfixFromBuffer() abort
  if s:IsQuickfixOrLocationList()
    " reload quickfix of location list as required
    if getwininfo(win_getid())[0].quickfix
      let l:is_quickfix = v:true
      cgetbuffer
    else
      let l:is_quickfix = v:false
      lgetbuffer
    endif

    " buffer is now marked as edited so close and reload
    " TODO there must be a nicer way
    bd!
    if l:is_quickfix
      copen
    else
      lopen
    endif
  else
    echom "Not a quickfix/locationlist"
  endif
endfunction

function! s:IsQuickfixOrLocationList() abort
  if getwininfo(win_getid())[0].loclist || getwininfo(win_getid())[0].quickfix
    return v:true
  else
    return v:false
  endif
endfunction
