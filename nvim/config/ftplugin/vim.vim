" Highlights function block
" TODO turn this into a object so can then do multiple levels
nnoremap <leader>vf ?function<cr>v/endfunction<cr>$

" echo's selection on line bellow
xnoremap <leader>ev yoechom '": ' . "

" Populates a location list with the functions in the current file
nnoremap <leader>lf :call LocationListFromPattern('^\(\s*\)\=function!\=.*(.*)\( abort\)\=$')<cr>
" command! -nargs=0 ListFunctions call LocationListFromPattern('^\(\s*\)\=function!\=.*(.*)\( abort\)\=$')
