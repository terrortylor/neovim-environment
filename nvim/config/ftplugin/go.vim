" vim-go is used for IDE like functionality, as mappings are only used in go
" define them here so that mappings that overlap with COC take presidence

" Always use quickfix
" TODO if do function to handle quickfix or location list then this can be
" removed
let g:go_list_type = "quickfix"

nmap <leader>gt <Plug>(go-test)
nmap <leader>gct <Plug>(go-coverage-toggle)
nnoremap <leader>gft :GoTestFunc<CR>
nnoremap <leader>gb :<C-u>call <SID>build_go_files()<CR>
nmap <leader>gr <Plug>(go-run)

" let g:go_diagnostics_enabled=0

" let g:go_statusline_duration = 5000

" Lifted straight out of https://github.com/fatih/vim-go/wiki/Tutorial
" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

nnoremap <leader>gb :<C-u>call <SID>build_go_files()<CR>

" Use goimports rather than gofmt so format and imports missing packages on
" write
let g:go_fmt_command = "goimports"
