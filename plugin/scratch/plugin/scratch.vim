  " Scratch buffer name
  if !exists('g:scratch_buffer_name')
   let g:scratch_buffer_name = 'scratch'
  endif

  " Scratch paste from register name
  if !exists('g:scratch_paste_register')
   let g:scratch_paste_register = '*'
  endif

  " Opens a scratch buffer, if one exists already open that
  command! Scratch call Scratch()
  " Puts the contents on the scratch_paste_register into the scratch buffer
  command! PasteToScratch call PasteToScratch()
