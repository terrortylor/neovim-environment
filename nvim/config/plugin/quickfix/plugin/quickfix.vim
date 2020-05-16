" Todo camel case all variables rwview google code practice
if exists('g:loaded_quickfix_plugin')
  finish
endif
let g:loaded_quickfix_plugin = 1

" The errorformat used when reading a modified list format
if !exists('g:quickfix_local_errorformat')
  let g:quickfix_local_errorformat = '%f\|%l\ col\ %c\|%m'
endif

" The configuration for external binary to use
if !exists('g:quickfix_search_binaries')
  let g:quickfix_search_binaries = {
    \ 'grep' : {
      \'bin' : 'grep',
      \'default_options' : '-rn',
      \'case_insensitive' : '-i'
    \ },
    \ 'ack' : {
      \ 'bin' : 'ack',
      \ 'default_options' : '-H --column --nofilter --nocolor --nogroup',
      \ 'case_insensitive' : '-i'
    \ }
  \ }
endif

" Sets the external binary to use, falls back to grep
if !exists('g:quickfix_external_binary')
  if executable('ack')
    let g:quickfix_external_binary = 'ack'
  else
    let g:quickfix_external_binary = 'grep'
  endif
endif

augroup quickfix_disable_numbers
  autocmd!
  autocmd BufReadPost quickfix nested set nonumber
  autocmd BufReadPost quickfix nested set norelativenumber
augroup END

" Opens a new tab with quickfix list open, selecting first item and some
" custom mappings
command! TabbedQuicklistViewer :call quickfix#tabbed#TabbedQuicklistViewer()<CR>

" Create command for global search in projct and view using
" TabbedQuicklistViewer to display results in new tab
command! -nargs=+ -complete=file_in_path -bar Grep :call quickfix#search#TabbedGrep(<f-args>)

" This is just a warpper for calling grep, and opening the quickfix list, but
" not jumping to first selection
command! -nargs=+ -complete=file_in_path -bar SimpleGrep :call quickfix#search#SimpleGrep(<f-args>)

" Create Plug mapping to make quickfix editable buffer
nnoremap <Plug>(QuicklistCreateEditableBuffer) :call quickfix#edit#SetModifiable()<CR>

" Create Plug mapping load take edited buffer and make quicklist
nnoremap <Plug>(QuickfixCreateFromBuffer) :call quickfix#edit#QuickfixFromBuffer()<CR>

" Apply changes made in quickfix and apply them to the relatvent files/lines
nnoremap <Plug>(QuickfixApplyLineChanges) :call quickfix#edit#MakeChangesInQuickfix()<CR>

  " {{{ Searching


  " }}} Searching
