" Import markdown filetype settings as base
runtime! ftplugin/markdown.vim

" Assign formatted date to p register
" Jump to 2nd line, insert date as markdown header
" move down a line
function! StartNewDay()
  let l:old_r = @r
  let @r = strftime('%A %d %B %Y')
  execute "normal! 2Go\<cr>\<esc>ki## \<esc>\"ppo\<cr>"
  let @r = l:old_r
endfunction
command! -nargs=0 StartNewDay call StartNewDay()

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

" Wrap Jira ticket number with link
vnoremap <leader>cl :<c-u>call WrapJiraTicketIntoLink()<cr>
function! WrapJiraTicketIntoLink() abort
  let l:old_m = @m
  let @m='gvygvc[0](https://oxygroup.atlassian.net/browse/0)'
  normal @m
  let @m = l:old_m
endfunction
