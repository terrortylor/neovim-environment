" vim-go is used for IDE like functionality, as mappings are only used in go
" define them here so that mappings that overlap with COC take presidence

" Always use quickfix
let g:go_list_type = "quickfix"

" Run all tests
nmap <leader>gt <Plug>(go-test)

" Run the test currently in
nnoremap <leader>gft :GoTestFunc<CR>

" Toggles test coverage on and off
nmap <leader>gct <Plug>(go-coverage-toggle)

nnoremap <leader>gb :<C-u>call <SID>build_go_files()<CR>

" Rename variable/word
nmap <leader>gr <Plug>(go-rename)

" Runs the program, note this is synchronous
nmap <leader>ge <Plug>(go-run)

" Toggle between file and test file
nnoremap <leader>ga :<C-u>GoAlternate!<CR>

" Show function signature and return type on status line
nmap <Leader>gfi <Plug>(go-info)

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

" Use goimports rather than gofmt so format and imports missing packages on
" write
let g:go_fmt_command = "goimports"

" Hover over a struct name to generate an interface for given struct
" The interface value is put in normal register
" If any argument(s) is passed then it also echom's the generated interface
function! GenerateInterface(...) abort
  if a:0 > 0
    let l:echom_func = v:true
  else
    let l:echom_func = v:false
  endif

  " Capture cursor position to be restored later with
  let [_, l:lnum, l:col, _] = getpos(".")
  try
    " Capture word under cursor
    let l:word_under_cursor = expand("<cword>")
    " Go to top of buffer
    normal! gg
    " Check that a struct exists with given name
    if search('\Ctype ' . l:word_under_cursor . ' struct') == 0
      echom 'Struct: ' . l:word_under_cursor . ' not found'
      return
    endif

    " capture all methods with receiver of type l:word_under_cursor
    let l:methods = execute(':g/func (.*' . l:word_under_cursor . ').*{')
    let functions = []
    call add(functions, 'type ' . l:word_under_cursor . 'Int interface {')

    for i in split(l:methods, '\n')
      " returns a line in the form of:
      " 12 func (self *List) DoThing(name string) error {
      " so remove crap to get:
      " DoThing(string) error
      let l:select_function_regex = '\v'              " Very magic
      let l:select_function_regex .= '^'              " From start of line
      let l:select_function_regex .= '\s{-}\d+\s'     " possible whitespace used as pcall adding, line number and single whitespace
      let l:select_function_regex .= 'func\s\(.*\)\s' " function declaration and possible receiver
      let l:select_function_regex .= '(\w+)'          " capture function name
      let l:select_function_regex .= '\(([^)]*)\)'    " capture function arguments for embedded substitute
      let l:select_function_regex .= '(.{-})\s\{'     " capture function return values

      " This is the entire substitute command as embeded in first, this is to
      " trim the function argument names to leave just the types
      let l:cleanse_argument_list_regex = '\=submatch(1) . "(" . '                          " function name and start of condition parentheses
      let l:cleanse_argument_list_regex .= 'substitute(submatch(2), "\\v\\w+\\s", "", "g")' "remove name of condition parameter to leave just the type
      let l:cleanse_argument_list_regex .= ' . ")" . submatch(3)'                           " end of condition parentheses and return values
      let l:transform_function_arguments = ''
      let l:trimmed = substitute(i, l:select_function_regex, l:cleanse_argument_list_regex, '')
      call add(functions, '    ' . l:trimmed)
    endfor
    call add(functions, '}')

    let @" = join(functions, "\n")

    echom 'Interface generated from scruct, put in default register'

    if l:echom_func == v:true
      call helper#echom#list(functions)
    endif

  finally
    " Restores cursor position
    call cursor(l:lnum, l:col)
  endtry
endfunction

" Hover over a struct name to generate an interface for given struct
" The interface value is put in normal register
" If any argument(s) is passed then it also echom's the generated interface
command! -nargs=? GoGenerateInterfaceFromStruct call GenerateInterface(<args>)
