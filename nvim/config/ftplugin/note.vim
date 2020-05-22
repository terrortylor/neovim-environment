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
