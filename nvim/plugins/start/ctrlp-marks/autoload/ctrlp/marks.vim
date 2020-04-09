" =============================================================================
" File:          autoload/ctrlp/marks.vim
" Description:   Example extension for ctrlp.vim
" =============================================================================

" To load this extension into ctrlp, add this to your vimrc:
"
"     let g:ctrlp_extensions = ['marks']
"
" Where 'marks' is the name of the file 'marks.vim'
"
" For multiple extensions:
"
"     let g:ctrlp_extensions = [
"         \ 'my_extension',
"         \ 'my_other_extension',


" " Load guard
" TODO uncommend this
if ( exists('g:loaded_ctrlp_marks') && g:loaded_ctrlp_marks )
	\ || v:version < 700 || &cp
	finish
endif
let g:loaded_ctrlp_marks = 1

call add(g:ctrlp_ext_vars, {
	\ 'init': 'ctrlp#marks#init()',
	\ 'accept': 'ctrlp#marks#accept',
	\ 'lname': 'registers',
	\ 'sname': 'registers',
	\ 'type': 'line',
	\ 'sort': 0,
	\ 'specinput': 0,
	\ })


" Provide a list of strings to search in
"
" Return: a Vim's List
"
function! ctrlp#marks#init()
  " TODO this should be a script variable
  let s = @a
  let s = split(s, "\n")[1:]
  for l in s
    echom ' ' . l
  endfor
  return s
endfunction

" TODO this should be script scoped
function! Scratch(text, command)
    split
    noswapfile hide enew
    setlocal buftype=nofile
    setlocal bufhidden=hide
    file scratch
    " TODO backup and restore register
    let @a = a:text
    silent execute 'normal "ap' . a:command
    "setlocal nobuflisted
    silent normal ggVG"ay
    bwipe
    return @a
endfunction



" The action to perform on the selected string
"
" Arguments:
"  a:mode   the mode that has been chosen by pressing <cr> <c-v> <c-t> or <c-x>
"           the values are 'e', 'v', 't' and 'h', respectively
"  a:str    the selected string
"
function! ctrlp#marks#accept(mode, str)
	" For this example, just exit ctrlp and run help
	call ctrlp#exit()

  let l:reg = trim(split(a:str)[0])
  execute('silent normal! `' . l:reg)
endfunction

" Give the extension an ID
let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)

" Allow it to be called later
function! ctrlp#marks#id()
	return s:id
endfunction

" Entry function, before calling ctrlp#init(ctrlp#marks#id()) which switches
" to ctrlp before running commands, capture output of marks so that buffer
" specspecific marks give line details not just filename
function! ctrlp#marks#domarks()
  let s = ''
  redir => s
  silent marks
  redir END
  let s = Scratch(s, "ddw\<c-v>Gwwx")
  let @a = s
  call ctrlp#init(ctrlp#marks#id())
endfunction

" vim:nofen:fdl=0:ts=2:sw=2:sts=2

