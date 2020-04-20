" TODO Expose function to send current line to REPL
" TODO Expose function to send current selection to REPL
if exists('g:loaded_terminal_plugin')
  finish
endif
let g:loaded_terminal_plugin = 1

" Playing with some terminal stuff
let s:debug = v:true

" TODO this should probably be prefixed with <leader>
tnoremap <Esc> <C-\><C-n>

" TODO is this used any more?
if !exists('g:terminals')
  let g:terminals = {}
endif

" TODO do these need to be global?
if !exists('g:repl_compile')
  let g:repl_compile = ''
endif

if !exists('g:repl_run')
  let g:repl_run = ''
endif

" Runs current file in a Terminal called 'REPL'
command! -nargs=0 TerminalReplFile call RunFileInTerminal()
command! -nargs=0 TRF TerminalReplFile

" Toggles the Repl Terminal
command! -nargs=0 TerminalReplFileToggle call s:ToggleTerminal('REPL')
command! -nargs=0 TRFC TerminalReplFileToggle

" TODO Better way of filetype detection to know what/how to run
augroup repl_filetype_executors
  autocmd!
  autocmd FileType kotlin
    \ let g:repl_compile = 'kotlinc' |
    \ let g:repl_run = 'java'
  autocmd FileType sh
    \ let g:repl_compile = '' |
    \ let g:repl_run = 'sh'
augroup END
