" A plugin inspired by vinegar, currently WIP
"
" Aims:
" * Manage`Lexplore` split so more tray like
" * Open open ability to target/jump to current file
" * jump up to next/previous directory or parent directory
" * Set vim CWD to selected directory, if file then files parent

let s:cpo_save = &cpo
set cpo&vim

" " Load guard
if exists('g:loaded_netrw_plugin')
	finish
endif
let g:loaded_netrw_plugin = 1

if !exists('g:netrw_tray_width')
 let g:netrw_tray_width = 40
endif

if !exists('g:netrw_setup_mappings')
  let g:netrw_setup_mappings = v:false
endif

" Configure netrw plugin to show file ls details
" See: https://shapeshed.com/vim-netrw/
let g:netrw_liststyle = 3
"
" Hide noisey banner
let g:netrw_banner = 0
" command! NetrwFind :call OpenAndLocateFile()

" Create some <Plug> mappings
nnoremap <silent> <Plug>RiceVinegarFind :call Open_and_locate_file()<CR>

let &cpo = s:cpo_save
unlet s:cpo_save
