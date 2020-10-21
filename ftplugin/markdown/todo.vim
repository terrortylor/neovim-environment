" Manage new line below current line in normal mode
nnoremap <Plug>(MarkdownNewLineBellow) o<C-R>=luaeval("require('markdown.tasks').insert_empty_task_box(true)")<CR>
" Manage new line above current line in normal mode
nnoremap <Plug>(MarkdownNewLineAbove) O<C-R>=luaeval("require('markdown.tasks').insert_empty_task_box(false)")<CR>
" plug mappings not really required at this point... :P
nmap <silent> o <Plug>(MarkdownNewLineBellow)
nmap <silent> O <Plug>(MarkdownNewLineAbove)

" Used to mark tasks as not done,start,done
nnoremap <Plug>(MarkdownCheckboxNotDone) :lua require('markdown.tasks').set_task_state(' ')<CR>
nnoremap <Plug>(MarkdownCheckboxStarted) :lua require('markdown.tasks').set_task_state('o')<CR>
nnoremap <Plug>(MarkdownCheckboxDone) :lua require('markdown.tasks').set_task_state('x')<CR>

nmap <leader>mt <Plug>(MarkdownCheckboxNotDone)
nmap <leader>ms <Plug>(MarkdownCheckboxStarted)
nmap <leader>md <Plug>(MarkdownCheckboxDone)

inoremap <Plug>(MarkdownlistNewLine) <C-O><cmd>lua require('markdown.tasks').handle_carridge_return()<cr>
imap <cr> <Plug>(MarkdownlistNewLine)
