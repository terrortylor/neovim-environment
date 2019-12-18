" TODO convert these to maps
if !exists('s:search_engine_google')
  let s:search_engine_google = 'www.google.com/search?q='
endif

if !exists('s:search_engine_duckduckgo')
  let s:search_engine_duckduckgo = 'www.duckduckgo.com/?q='
endif

if !exists('s:exe_chrome')
  let s:exe_chrome = 'google-chrome'
endif

if !exists('s:exe_firefox')
  let s:exe_firefox = 'firefox'
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

  if g:websearch_browser ==? "chrome"
    let l:browser = s:exe_chrome
  elseif g:websearch_browser ==? "firefox"
    let l:browser = s:exe_firefox
  endif

  if g:websearch_search_engine ==? "google"
    let l:engine = s:search_engine_google
  elseif g:websearch_search_engine ==? "duckduckgo"
    let l:engine = s:search_engine_duckduckgo
  endif

  let l:command = "!" . l:browser . " '" . l:engine . a:search . "' &"

  return l:command
endfunction

nnoremap <silent> <leader>gs :<C-u>call WebSearch(visualmode())<CR>
vnoremap <silent> <leader>gs :<C-u>call WebSearch(visualmode())<Cr>
