" Manage new line below current line in normal mode
nnoremap <buffer> <Plug>(MarkdownNewLineBellow) o<C-R>=luaeval("require('markdown.tasks').insert_empty_task_box(true)")<CR>
" Manage new line above current line in normal mode
nnoremap <buffer> <Plug>(MarkdownNewLineAbove) O<C-R>=luaeval("require('markdown.tasks').insert_empty_task_box(false)")<CR>
" plug map <buffer>pings not really required at this point... :P
nmap <buffer> <silent> o <Plug>(MarkdownNewLineBellow)
nmap <buffer> <silent> O <Plug>(MarkdownNewLineAbove)

" Used to mark tasks as not done,start,done
nnoremap <buffer> <Plug>(MarkdownCheckboxNotDone) :lua require('markdown.tasks').set_task_state(' ')<CR>
nnoremap <buffer> <Plug>(MarkdownCheckboxStarted) :lua require('markdown.tasks').set_task_state('o')<CR>
nnoremap <buffer> <Plug>(MarkdownCheckboxDone) :lua require('markdown.tasks').set_task_state('x')<CR>

nmap <buffer> <leader>mt <Plug>(MarkdownCheckboxNotDone)
nmap <buffer> <leader>ms <Plug>(MarkdownCheckboxStarted)
nmap <buffer> <leader>md <Plug>(MarkdownCheckboxDone)

inoremap <buffer> <Plug>(MarkdownlistNewLine) <C-O><cmd>lua require('markdown.tasks').handle_carridge_return()<cr>
" TODO why was this added to a ts file?
imap <buffer> <cr> <Plug>(MarkdownlistNewLine)
