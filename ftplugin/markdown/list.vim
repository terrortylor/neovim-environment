" Custom handling of lists within markdown, suggests online were to user
" comments and formatoptions settings but I didn't like the wrapping and it
" I also wanted to do custom checkbox lists so... this hooks into:
" Normal Mode:
"   o - if on starting line of list item then adds new list marker bellow at
"   correct indent
"   O - if on starting line of list item then adds new list market above at
"   correct indent level
" Insert Mode:
"  <CR> - if in a list then adds new line with list marker at correct indent
"       - if in a list and hit <CR> on empty list item then list terminated,
"       empty list item removed and new line added
"       - if in a list and current line is wrapped then add new list item with
"       correct indent
"  >    - on new list item to indent right
"  <    - on new list item to indent left

" TODO move to plugin, with ftplugin directory?
" TODO be good to move this to a plugin that can then be applied to multiple
" fileftypes like git commits

" later on, so when marker is got if checkbox then return an empty box
if !exists('s:regex_list_markers')
  " Note this assumes regex is very magic
  " This will match:
  "   -
  "   *
  "   - [ ]         Empty checkbox
  "   - [o]         Partly done checkbox
  "   - [x]         Done checkbox
  let s:regex_list_markers = '[\*|-](\s\[[[:space:]|x|o]\])?'
endif

if !exists('s:regex_list_indent')
  " Note this assumes regex is very magic
  let s:regex_list_indent = '^(\s+)?'
endif

" If <CR> is pressed in insert mode and line is empty list then remove line
" and start new empty line
function! s:NewLineListContinue() abort
  if !pumvisible()
    " if can't find marker on line than not a list line
    let [l:marker, l:indent] = s:InComment()
    if l:marker !=# ''
      " if list item is empty then delete line and start new line
      if getline('.') =~ '\v' . s:regex_list_indent . s:regex_list_markers . '(\s{-})$'
        return "\<ESC>0Di\<CR>"
      endif

      " if returned indent is greater than 0 then use that ident as comming
      " from wrapped line
      if  len(l:indent) > 0
        return "\<CR>\<ESC>0Di" . l:indent . l:marker ."\<space>"
      else
      " otherwise continue list on new line
        return "\<CR>" . l:marker . "\<space>"
      endif
    endif
  endif
  return "\<CR>"
endfunction

" Used after standard `o` and `O` mapping
" If line just jumped from matches a list item
" Capture list marker and insert it, identing is driven from
function! s:PreviousLineComment(direction) abort
  if a:direction ==# 'o'
    let l:linenr = line('.')-1
  elseif a:direction ==# 'O'
    let l:linenr = line('.')+1
  endif

  let l:marker = s:GetLineMarker(l:linenr)
  if l:marker !=# ''
   return l:marker . ' '
  endif

  return ''
endfunction

function! s:GetLineMarker(line) abort
  let l:line = getline(a:line)
  let  l:list_marker = matchstr(l:line, '\v' . s:regex_list_indent . '\zs' . s:regex_list_markers . '\ze\s')
  return l:list_marker
endfunction

" Checks if line is comment, if not searches in direction for next line with
" different indenting (i.e. a list marker) and then checks if comment, and if
" so grabs marker
"
" Returns list marker value and indent if from wrapped line
function! s:InComment() abort
  " check if current line is list item
  let l:marker = s:GetLineMarker('.')
  " FIXME doesn't take into account * [ ] checkboxes
  if !empty(matchstr(l:marker, '-\s\['))
    let l:marker = '- [ ]'
  endif
  " Check if marker is checkbox, and return empty checkbox
  if l:marker !=# ''
    return [l:marker, '']
  endif

  " check to see if in warped text
  " get indent of current line
  let  l:indent = len(matchstr(getline('.'), '^\v\zs' . s:regex_list_indent . '\ze\S'))
  if  l:indent > 0
    " get line number of where list started
    " TODO based on direction add bz (backwards) if o or nothing if O
    let l:line = search('\v^\s{,' . (l:indent - 1) .'}\s', 'bznW')
    if l:line > 0
      let l:marker = s:GetLineMarker(l:line)
      if l:marker !=# ''
        let  l:indent = matchstr(getline(l:line), '\v\zs' . s:regex_list_indent . '\ze\S')
        return [l:marker, l:indent]
      endif
    endif
  endif
  return ['', '']
endfunction

" Indent's line in insert mode, if a list item. Only indents if no test after
" list bullet point, otherwise inserts the `<` or `>` charecter.
function! IndentListItem(direction) abort
  if getline('.') =~ '\v' . s:regex_list_indent . s:regex_list_markers . '(\s{-})$'
    return "\<c-g>u\<ESC>V" . a:direction . "\<ESC>A"
  endif
  return a:direction
endfunction

function! s:MarkCheckboxAs(state) abort
  " check if current line is list item
  let l:marker = s:GetLineMarker('.')
  if !empty(matchstr(l:marker, '-\s\['))
    let l:line = getline('.')
    let l:line = substitute(l:line, '\v' . s:regex_list_indent . '-\s\[.{1}\]', '\1- [' . a:state . ']', 'g')
    call setline('.', l:line)
  endif
endfunction

" Manage new lines in lists in insert mode
inoremap <Plug>(MarkdownlistNewLine) <C-R>=<SID>NewLineListContinue()<CR>
" Manage new line below current line in normal mode
nnoremap <Plug>(MarkdownNewLineBellow) o<C-R>=<SID>PreviousLineComment('o')<CR>
" Manage new line above current line in normal mode
nnoremap <Plug>(MarkdownNewLineAbove) O<C-R>=<SID>PreviousLineComment('O')<CR>
" Indent new list item right in insert mode
inoremap <Plug>(MarkdownListIndentRight) <C-R>=IndentListItem('>')<CR>
" Indent new list item left in insert mode
inoremap <Plug>(MarkdownListIndentLeft) <C-R>=IndentListItem('<')<CR>
" Used to mark todos as not done,start,done
nnoremap <Plug>(MarkdownCheckboxNotDone) :call <SID>MarkCheckboxAs(' ')<CR>
nnoremap <Plug>(MarkdownCheckboxStarted) :call <SID>MarkCheckboxAs('o')<CR>
nnoremap <Plug>(MarkdownCheckboxDone) :call <SID>MarkCheckboxAs('x')<CR>

imap > <Plug>(MarkdownListIndentRight)
imap < <Plug>(MarkdownListIndentLeft)
imap <cr> <Plug>(MarkdownlistNewLine)
nmap <silent> o <Plug>(MarkdownNewLineBellow)
nmap <silent> O <Plug>(MarkdownNewLineAbove)
nmap <leader>mt <Plug>(MarkdownCheckboxNotDone)
nmap <leader>ms <Plug>(MarkdownCheckboxStarted)
nmap <leader>md <Plug>(MarkdownCheckboxDone)
