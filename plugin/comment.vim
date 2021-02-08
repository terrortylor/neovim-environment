if exists('g:loaded_comment_plugin')
  finish
endif
let g:loaded_comment_plugin = 1

let g:loaded_text_objects_plugin = 1
function! Comment(type) abort
  let l:sel_save = &selection
  let &selection = "inclusive"
  let l:reg_save = @@

  execute "lua require('ui.buffer.comment').operator()"

  let &selection = l:sel_save
  let @@ = l:reg_save
endfunction

nnoremap gcc :CommentToggle<cr>
nnoremap gc :set operatorfunc=Comment<cr>g@
vnoremap gc :<c-u>call Comment(visualmode())<cr>
