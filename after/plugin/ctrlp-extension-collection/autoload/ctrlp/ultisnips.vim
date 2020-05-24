" =============================================================================
" File:          autoload/ctrlp/ultisnips.vim
" Description:   Look up snippets for scope of current buffer and activate
"                it.
" =============================================================================

" Load guard
if ( exists('g:loaded_ctrlp_ultisnips') && g:loaded_ctrlp_ultisnips )
	\ || v:version < 700 || &cp
	finish
endif
let g:loaded_ctrlp_ultisnips = 1


" Add this extension's settings to g:ctrlp_ext_vars
call add(g:ctrlp_ext_vars, {
	\ 'init': 'ctrlp#ultisnips#init()',
	\ 'accept': 'ctrlp#ultisnips#accept',
	\ 'lname': 'List and select scoped snippet',
	\ 'sname': 'snippets',
	\ 'type': 'line',
	\ 'enter': 'ctrlp#ultisnips#enter()',
	\ 'sort': 0,
	\ 'specinput': 0,
	\ })


" Provide a list of strings to search in
"
" Return: a Vim's List
"
function! ctrlp#ultisnips#init()
  return s:snippet_list
endfunction

" The action to perform on the selected string
"
" Arguments:
"  a:mode   the mode that has been chosen by pressing <cr> <c-v> <c-t> or <c-x>
"           the values are 'e', 'v', 't' and 'h', respectively
"  a:str    the selected string
"
function! ctrlp#ultisnips#accept(mode, str)
	" For this example, just exit ctrlp and run help
	call ctrlp#exit()

  " Ignore mode as always want to trigger from current window/cursor position
  let l:snippet_trigger = trim(split(a:str, '|')[0])

  " execute("normal! i" . l:snippet_trigger . "\<C-R>=UltiSnips#ExpandSnippet()<CR>")
  execute "silent normal! i" . l:snippet_trigger . "\<C-R>=UltiSnips#ExpandSnippet()\<CR>"
endfunction


" Capture ultisnips in scope of current file
function! ctrlp#ultisnips#enter()
  " check as expression
  call UltiSnips#SnippetsInCurrentScope(1)
  let l:list = []
  let l:max_len = 0
  for [key, info] in items(g:current_ulti_dict_info)
    if l:max_len < len(key)
      let  l:max_len = len(key)
    endif
  endfor

  for [key, info] in items(g:current_ulti_dict_info)
    let parts = split(info.location, ':')
    call add(l:list, printf("%" . l:max_len . "s", key) . ' | ' . info.description)
  endfor
  let s:snippet_list = l:list

  call ctrlp#init(ctrlp#ultisnips#id())
endfunction

" Give the extension an ID
let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)

" Allow it to be called later
function! ctrlp#ultisnips#id()
	return s:id
endfunction

" vim:nofen:fdl=0:ts=2:sw=2:sts=2
