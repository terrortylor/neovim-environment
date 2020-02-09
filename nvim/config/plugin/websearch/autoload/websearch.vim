if !exists('s:search_engines')
  let s:search_engines = {'google' : 'www.google.com/search?q=', 'duckduckgo' : 'www.duckduckgo.com/?q='}
endif

if !exists('s:browsers')
  let s:browsers = {'chrome' : 'google-chrome', 'firefox' : 'firefox'}
endif

function! WebSearch(type) abort
  " Store current selection setting and @@ register
  let l:sel_save = &selection
  let &selection = "inclusive"
  let l:reg_save = @@

  if a:type ==? "v" " invoked from visual mode
    silent exe "normal! `<" . a:type . "`>y"
  elseif a:type ==? "V" " invoked from visual line mode
    silent exe "normal! '[V']y"
  else
    " invoved from normal mode so select current word
    " silent exe "normal! `[v`]y"
    silent exe "normal! viwy"
  endif

  let l:command = websearch#BuildSearchCommand()
  echom l:command
  silent exe l:command

  " Restore current selection setting and @@ register
  let &selection = l:sel_save
  let @@ = l:reg_save
endfunction

function! websearch#BuildSearchCommand() abort
  if g:websearch_include_filetype
    let filetype = ""
    if &ft != "text"
        let filetype = &ft . "+"
    endif
    let a:search = filetype . substitute(trim(@@), ' \+', '+', 'g')
  else
    let a:search = substitute(trim(@@), ' \+', '+', 'g')
  endif

  if has_key(s:browsers, g:websearch_browser)
    let l:browser = get(s:browsers, g:websearch_browser)
  else
    echom "Browser: " . g:websearch_browser . " not found"
    return ""
  endif

  if has_key(s:search_engines, g:websearch_search_engine)
    let l:engine = get(s:search_engines, g:websearch_search_engine)
  else
    echom "Search engine: " . g:websearch_search_engine . " not found"
    return ""
  endif

  let l:command = "!" . l:browser . " '" . l:engine . a:search . "' &"

  return l:command
endfunction

" TODO expose commands here and move mappings to vimrc
nnoremap <silent> <leader>gs :<C-u>call WebSearch(visualmode())<CR>
vnoremap <silent> <leader>gs :<C-u>call WebSearch(visualmode())<Cr>
