" This clashed with an ultisnips mapping set in the plugin, to expand on TAB.
" This behaviour is still required but we also want to select from PUM with
" <TAB>
" Use <TAB> to select from PUM
inoremap <expr> <TAB> pumvisible() ? "\<C-y>" : "\<TAB>"
