" Assign formatted date to p register
" Jump to 2nd line, insert date as markdown header
" move down a line
function! StartNewDay()
  let @p = strftime('%A %d %B %Y')
  execute "normal! 2Go\<cr>\<esc>ki## \<esc>\"ppo\<cr>"
endfunction

" TODO does vim-markdown break this... is it still required?
" " Auto create TOC on buf write is a note
" augroup notebufwritegroup
"   autocmd!
"   autocmd BufWrite *.md CreateTOC
" augroup END

" Add markdown snippets to note type
UltiSnipsAddFiletypes note.markdown

" Mark todo item as todo
nnoremap <leader>mt :call MarkAsTodo()<cr>
function! MarkAsTodo() abort
  let l:old_m = @m
  let @m='dd/^## TODOjp'
  normal @m
  let @m = l:old_m
endfunction

" Mark todo item as done
nnoremap <leader>md :call MarkTodoDone()<cr>
function! MarkTodoDone() abort
  let l:old_m = @m
  let @m='dd/^## DONEjp'
  normal @m
  let @m = l:old_m
endfunction
