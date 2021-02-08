lua require 'config'

" This is for plasticboy/vim-markdown
" Don't require .md extension
let g:vim_markdown_no_extensions_in_markdown = 1

" Autosave when following links
let g:vim_markdown_autowrite = 1

function! QuickfixMappings() abort
  nmap <leader>ce <Plug>(QuicklistCreateEditableBuffer)
  nmap <leader>cs <Plug>(QuickfixCreateFromBuffer)
  nmap <leader>ca <Plug>(QuickfixApplyLineChanges)

  nnoremap [C :colder<cr>
  nnoremap ]C :cnewer<cr>
endfunction

augroup quickfix_mappings
  autocmd!
  " autocmd BufReadPost quickfix nested :call QuickfixMappings()
  autocmd WinEnter * if &buftype == 'quickfix' | call QuickfixMappings() | endif
augroup END

" Custom global search within buffer, displays results in location list
" just clears it self
nnoremap <leader>fb :FindInBuffer<space>
" Custom global search within buffer using selection, displays results in location list
vnoremap <leader>fb y:FindInBuffer <c-r>"<cr>
"" Custom Grep (tabbed view) for selection within current directory, path can
"" be added
"vnoremap <leader>ftp y:Grep <c-r>"
"" Custom Grep (tabbed view) within current directory, path can
"" be added
"nnoremap <leader>ftp :Grep
"" Custom Grep for selection within current directory with standard quickfix
"" window, path can be added
"vnoremap <leader>fp y:SimpleGrep <c-r>"
"" Custom Grep within current directory with standard quickfix
"" window, path can be added
"nnoremap <leader>fp y:SimpleGrep

" Open NERDTree at current file location, close if open
" Takes into account in a buffer is loaded or not
function! NerdToggleFind()
  if exists("g:NERDTree")
    " If no buffer has been loaded
    if @% == ""
      NERDTreeToggle
    else
      " if nerdtree is open
      if g:NERDTree.IsOpen()
        " if nerdtree focused then close
        if bufwinnr(t:NERDTreeBufName) == winnr()
          NERDTreeToggle
        else
          NERDTreeFind
        endif
      else
        NERDTreeFind
      endif
    endif
  endif
endfunction

" Opens first non empty list, location list is local to window
nnoremap <leader>cl :call quickfix#window#OpenList()<CR>
" Close all quicklist windows
nnoremap <leader>cc :call quickfix#window#CloseAll()<CR>
