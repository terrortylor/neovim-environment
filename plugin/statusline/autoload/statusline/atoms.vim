" NOTE depends on termguicolors being on
" This is set in my vimrc
hi AtomStatusLine guifg=NONE guibg=#383843
hi AtomBracket guifg=#ff8a7a guibg=#383843
hi AtomColon guifg=#8dbf67 guibg=#383843
hi AtomText guifg=#4ec4e6 guibg=#383843
" TODO Choose some better colours
hi AtomNormal guifg=#8dbf67 guibg=#383843
hi AtomInsert guifg=#8dbf67 guibg=#383843
hi AtomReplace guifg=#8dbf67 guibg=#383843
hi AtomVisual guifg=#8dbf67 guibg=#383843
hi AtomCommand guifg=#8dbf67 guibg=#383843
hi AtomSelect guifg=#8dbf67 guibg=#383843
hi AtomTerminal guifg=#8dbf67 guibg=#383843

let s:statusline_modes = {
  \ 'n'      : {
  \   'display'   : 'NORMAL',
  \   'highlight' : 'AtomNormal'
  \ },
  \ 'i'      : {
  \   'display'   : 'INSERT',
  \   'highlight' : 'AtomInsert'
  \ },
  \ 'R'      : {
  \   'display'   : 'REPLACE',
  \   'highlight' : 'AtomReplace'
  \ },
  \ 'v'      : {
  \   'display'   : 'VISUAL',
  \   'highlight' : 'AtomVisual'
  \ },
  \ 'V'      : {
  \   'display'   : 'VISUAL-LINE',
  \   'highlight' : 'AtomVisual'
  \ },
  \ "\<C-v>" : {
  \   'display'   : 'VISUAL-BLOCK',
  \   'highlight' : 'AtomVisual'
  \ },
  \ 'c'      : {
  \   'display'   : 'COMMAND',
  \   'highlight' : 'AtomCommand'
  \ },
  \ 's'      : {
  \   'display'   : 'SELECT',
  \   'highlight' : 'AtomSelect'
  \ },
  \ 'S'      : {
  \   'display'   : 'SELECT-LINE',
  \   'highlight' : 'AtomSelect'
  \ },
  \ "\<C-s>" : {
  \   'display'   : 'SELECT-BLOCK',
  \   'highlight' : 'AtomSelect'
  \ },
  \ 't'      : {
  \   'display'   : 'TERMINAL',
  \   'highlight' : 'AtomTerminal'
  \ }
\}

function! s:WrapWithBrackets(atom) abort
 if strlen(a:atom) > 0
   return '%#AtomBracket#[' . a:atom . '%#AtomBracket#]'
 endif
 return ''
endfunction

" TODO some fancy trucation could happen here
function! statusline#atoms#filename() abort
 return '%#AtomText#%f'
endfunction

function! statusline#atoms#readonly(winnr) abort
  let l:readonly = getwinvar(a:winnr, '&readonly')
  if l:readonly == 0
    return ''
  endif
  return s:WrapWithBrackets('%#AtomText#RO')
endfunction

function! statusline#atoms#modified(winnr) abort
  let l:modified = getwinvar(a:winnr, '&modified')
  if modified == 0
    return ''
  endif
  return s:WrapWithBrackets('%#AtomText#+')
endfunction

function! statusline#atoms#non_modifiable(type) abort
  return s:WrapWithBrackets('%#AtomText#' . a:type)
endfunction

function! statusline#atoms#case_sensitivity() abort
  let l:atom='%#AtomText#'
  let l:atom .= &ignorecase ? '*aA*' : 'aA'
  return s:WrapWithBrackets(l:atom)
endfunction

function! statusline#atoms#filetype(winnr) abort
  let l:atom='%#AtomText#'
  let l:filetype = getwinvar(a:winnr, '&filetype')
  let l:atom .= l:filetype !=# '' ? toupper(filetype) : 'NONE'
  return s:WrapWithBrackets(l:atom)
endfunction

function! statusline#atoms#location() abort
  return s:WrapWithBrackets('%#AtomText#%l%#AtomColon#/%#AtomText#%L %c')
endfunction

" Run as sub shell
function! s:get_git_branch()
  return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! statusline#atoms#git_branch()
  if g:statusline_show_git_branch == v:false
    return ''
  endif
  let l:branchname = s:get_git_branch()
  let l:atom = '%#AtomGit#'
  let l:atom .= strlen(l:branchname) > 0 ? l:branchname : ''
  return s:WrapWithBrackets(l:atom)
endfunction

function! statusline#atoms#mode(active) abort
  if g:statusline_show_mode == v:false
    return ''
  endif
  " Work out max mode display length for padding
  if !exists('s:mode_max_length')
    let s:mode_max_length = 0
    for i in keys(s:statusline_modes)
      if s:mode_max_length < strchars(get(s:statusline_modes, i).display)
        let s:mode_max_length = strchars(get(s:statusline_modes, i).display)
      endif
    endfor
  endif

  if a:active == 1
    if has_key(s:statusline_modes, mode())
      let l:display = get(s:statusline_modes, mode()).display
      let l:atom = ' %#' . get(s:statusline_modes, mode()).highlight . '#'
      let l:atom .= l:display . ' '
      " Want to fix the length so swtiching windows doesn't make text jump
      " around
      return s:WrapWithBrackets(l:atom) . repeat(' ', s:mode_max_length - strchars(l:display) -1) . ' '
    endif
  else
    return repeat(' ', s:mode_max_length + 4)
  endif
endfunction
