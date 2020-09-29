" Manage new line below current line in normal mode
nnoremap <Plug>(MarkdownNewLineBellow) o<C-R>=luaeval("require('markdown.todo').insert_empty_todo_box(true)")<CR>
" Manage new line above current line in normal mode
nnoremap <Plug>(MarkdownNewLineAbove) O<C-R>=luaeval("require('markdown.todo').insert_empty_todo_box(false)")<CR>
" plug mappings not really required at this point... :P
nmap <silent> o <Plug>(MarkdownNewLineBellow)
nmap <silent> O <Plug>(MarkdownNewLineAbove)

" Used to mark todos as not done,start,done
nnoremap <Plug>(MarkdownCheckboxNotDone) :lua require('markdown.todo').set_todo_state(' ')<CR>
nnoremap <Plug>(MarkdownCheckboxStarted) :lua require('markdown.todo').set_todo_state('o')<CR>
nnoremap <Plug>(MarkdownCheckboxDone) :lua require('markdown.todo').set_todo_state('x')<CR>

nmap <leader>mt <Plug>(MarkdownCheckboxNotDone)
nmap <leader>ms <Plug>(MarkdownCheckboxStarted)
nmap <leader>md <Plug>(MarkdownCheckboxDone)

inoremap <Plug>(MarkdownlistNewLine) <C-O><cmd>lua require('markdown.todo').handle_carridge_return()<cr>
imap <cr> <Plug>(MarkdownlistNewLine)
