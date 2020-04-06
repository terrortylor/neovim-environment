" set the filetype to custom note + standard markdown
function! SetFiletypeIfNote()
  " get file path
  let l:path = expand('%:p')
  if l:path =~ 'workspace/notes'
    set filetype=note.markdown
  end
endfunction

autocmd BufNewFile,BufRead *.md call SetFiletypeIfNote()
