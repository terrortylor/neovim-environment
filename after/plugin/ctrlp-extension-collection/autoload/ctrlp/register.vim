" =============================================================================
" File:          autoload/ctrlp/register.vim
" Description:   Extends the `register` command so that the output can be
"                searched with ctrlp, the contents of the register is then put into the
"                buffer. Note register contents is [p]ut not [P]ut
" =============================================================================

" TODO work out how to conrol filter or what's displayed to user

" Load guard
if ( exists('g:loaded_ctrlp_register') && g:loaded_ctrlp_register )
	\ || v:version < 700 || &cp
	finish
endif
let g:loaded_ctrlp_register = 1


" Add this extension's settings to g:ctrlp_ext_vars
call add(g:ctrlp_ext_vars, {
	\ 'init': 'ctrlp#register#init()',
	\ 'accept': 'ctrlp#register#accept',
	\ 'lname': 'long statusline name',
	\ 'sname': 'shortname',
	\ 'type': 'line',
	\ 'sort': 0,
	\ 'specinput': 0,
	\ })

" Provide a list of strings to search in
"
" Return: a Vim's List
"
function! ctrlp#register#init()
  let registers = ''
  redir => registers
  silent register
  redir END

  " convert to list and remove first line
  let s = split(registers, "\n")[1:]
  for l in s
    echom l
  endfor
  return s
endfunction

" The action to perform on the selected string
" Note: mode is ignored
"
" Arguments:
"  a:mode   the mode that has been chosen by pressing <cr> <c-v> <c-t> or <c-x>
"           the values are 'e', 'v', 't' and 'h', respectively
"  a:str    the selected string
"
function! ctrlp#register#accept(mode, str)
	" For this example, just exit ctrlp and run help
	call ctrlp#exit()
  " Trim line, and remove prefixed " to get reg name
  let reg = substitute(split(a:str)[0], '"', '', '')
  echom reg
  execute('silent normal! "' . l:reg . 'p')
endfunction

" Give the extension an ID
let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)

" Allow it to be called later
function! ctrlp#register#id()
	return s:id
endfunction

" vim:nofen:fdl=0:ts=2:sw=2:sts=2
