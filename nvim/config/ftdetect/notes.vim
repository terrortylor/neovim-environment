" set the filetype to custom note + standard markdown
function! SetFiletypeIfNote()
  " get file path
  let l:path = expand('%:p')
  if l:path =~ 'workspace/notes'
    set filetype=note.markdown
  end
endfunction

" TODO writing TOC is causing issues
" autocmd BufNewFile,BufRead *.md call SetFiletypeIfNote()
