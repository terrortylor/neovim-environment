" Marks a quickfix / location list as modifiable
function! quickfix#edit#SetModifiable() abort
  if s:IsQuickfixOrLocationList()
    set modifiable

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
    " Set errorformat to read buffer in with
    execute('setlocal errorformat=' . g:quickfix_local_buffer_errorformat)

    " reload quickfix of location list as required
    if getwininfo(win_getid())[0].quickfix
      let l:is_quickfix = v:true
      cgetbuffer
    else
      let l:is_quickfix = v:false
      lgetbuffer
    endif

    call s:CloseModifiedListAndReOpen(l:is_quickfix)
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

function! s:CloseModifiedListAndReOpen(is_quickfix) abort
  "buffer is now marked as edited so close and reload
  setlocal nomodifiable nomodified
  bdelete

  if a:is_quickfix
    copen
  else
    lopen
  endif
endfunction

" Applies changes made in modified 'quickfix'
" NOTE, if you change the filename, line or col information this the change
" isn't applied
"
" TODO this doesn't work on location lists yet
" TODO if list loaded from modified buffer then and indentaion is lost in
" qflist entery, this is checked on buffer line to make sure qflist not stale
" so the to the quickfix#edit#QuickfixFromBuffer function needs to be updated
" so that indentation is kept
function! quickfix#edit#MakeChangesInQuickfix()abort
  let l:buffer_lines = getbufline('%', 0, "$")
  let l:qflist = getqflist()

  let l:count = 0
  for i in l:buffer_lines
    let l:buffer_line = l:buffer_lines[l:count]
    let l:filename = split(l:buffer_line, '|')[0]
    let l:buf_line = split(split(l:buffer_line, '|')[1])[0]
    let l:text = split(l:buffer_line, '|')[2]
    " the buffer text has a single padded 'space' prefix for formatting,
    " remove this
    let l:text = substitute(l:text, '^\s', '', '')

    let l:qf_line = l:qflist[l:count]
    let l:qf_bufnr = l:qf_line.bufnr
    let l:qf_filename = bufname(l:qf_bufnr)
    let l:qf_buf_line = l:qf_line.lnum
    let l:qf_text = l:qf_line.text

    " if filename and line number are the same but text different then look at editing
    " text
    " A little sanity checking to make sure potentially editing correct buffer
    " and line
    if l:filename ==# l:qf_filename && l:buf_line ==# l:qf_buf_line
    " fq entry text may have indentation which has been stripped so capture this
      let l:padding = substitute(l:qf_text, '\(^\s\{-\}\)\S.*', '\1', '')
      let l:padded_buf_text = l:padding . l:text

      if l:padded_buf_text !=# l:qf_text
        " Check buffer is loaded, any grep matches in files that aren't
        " currenty loaded (open) buffers are 'unloaded' which we edit
        " To add another level of sanity checking we check that the currnt
        " line is the same as the qf entry text before changing i.e. it hasn't
        " been edited
        if bufloaded(l:qf_bufnr) == 0
          let l:buf_was_loaded = v:false
          call bufload(l:qf_bufnr)
        else
          let l:buf_was_loaded = v:true
        endif


        " Check if loaded buffer line matches original qf line text, if not do
        " not update as qf out of date
        let l:loaded_buf_text = getbufline(l:qf_bufnr, l:qf_buf_line)[0]
        if l:loaded_buf_text ==# l:qf_text
          " Update buffer line, write buffer, update qf line text
          call setbufline(l:qf_bufnr, l:qf_buf_line, l:padding . l:text)
          " TODO be nice if this was moved to start of loop, if previous
          " buffer nr not empty and not the same then write, and then also can
          " use the no undo thing on the sebufline so that a buffers changes
          " are a single undo action
          silent! execute l:qf_bufnr . "bufdo write"
          " TODO think a copy is always returned so need to rebuild and set?
          " eugh all because of possible padding
          let l:qf_line.text = l:padding . l:text
        else
          echom "Buffer line doesn't match QF line entry before change, not updating as QF line out of date:" . l:filename . ":" . l:buf_line

          " If no change was made and the buffer wasn't loaded then unload to
          " prevent polution of buffers list
          if l:buf_was_loaded == v:false
            call bunload(l:qf_bufnr)
          endif
        endif
      endif
    endif
    let l:count += 1
  endfor

  " Finally set qflist as the newley changed list
  call setqflist(l:qflist)

  call s:CloseModifiedListAndReOpen(v:true)
endfunction
