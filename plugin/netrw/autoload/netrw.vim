" Open netrw and locate file
function! Open_and_locate_file() abort
  let l:buf_name = expand('%:t')
  echom 'l:buf_name: ' . l:buf_name
  " Open netrw
  execute 'Lexplore'
  " Resize it to a more suitable width
  execute 'vertical resize ' . g:netrw_tray_width
  " Locate buffername in netrw
  " TODO this only works if opened with current file visible
  " execute 'silent normal! /' . l:buf_name . "\r"
endfunction

augroup netrw_mappings
  autocmd!
  autocmd FileType netrw call s:setup_mappings()
augroup END

function! s:setup_mappings() abort
  echom 'in setup'
  " Disable a mappings that either don't use or get in the way
  call s:nunmap('i')
  call s:nunmap('o')

  " Set up custom mappings
  nnoremap <buffer> gg <Plug>NetrwLocalBrowseCheck

  " Add mapping to go and down by directories
  " TODO these do not work in mapping
  nnoremap <buffer> J :nohlsearch<ESC>/\v^\|.*\/<cr>
  nnoremap <buffer> K :nohlsearch<ESC>?\v^\|.*\/<cr>
endfunction

function! s:nunmap(name) abort
  if maparg(a:name, 'n') !=# ''
    execute 'nunmap <buffer> ' . a:name
  endif
endfunction
