" set the filetype to custom note + standard markdown
function! SetFiletypeIfNote()
  " get file path
  let a:path = expand('%:p')
  if a:path =~ 'workspace/notes'
    set filetype=note.markdown
  end
endfunction

autocmd BufNewFile,BufRead *.md call SetFiletypeIfNote()
