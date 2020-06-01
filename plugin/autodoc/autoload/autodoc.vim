if !exists('s:find_mapping_regex')
  let s:find_mapping_regex = '\v^(\s+)?[nvicsxolt]?(nore)?map'
endif

if !exists('s:find_command_regex')
  let s:find_command_regex =  '\v^command(!)?'
endif


" TODO add ability to look for <Plug> declarations and commands in autoload
" and plugin/xxx locations
function! GenerateDocumentationTags() abort
  " Want all actions to be carried out as single action, so user can undo with
  " single 'u' press, set has been editied as false
  let s:has_edited = v:false

  " Generate init.vi mappings tags
  call AddAutoDocumentationMarker('mappings', 'init.vim')

 " Generate ftplugin mappings tags
  for full_ftplugin_path in split(globpath(g:autodoc_config_path . '/ftplugin', '*'), '\n')
    let l:ftplugin_filename = s:GenerateFtpluginFilename(full_ftplugin_path)

    call AddAutoDocumentationMarker('mappings', 'ftplugin/' . l:ftplugin_filename)
  endfor

  " Generate init.vi commands tags
  call AddAutoDocumentationMarker('commands', 'init.vim')

 " Generate ftplugin commands tags
  for full_ftplugin_path in split(globpath(g:autodoc_config_path . '/ftplugin', '**/*.vim'), '\n')
    let l:ftplugin_filename = substitute(full_ftplugin_path, g:autodoc_config_path . '/', '', '')

    call AddAutoDocumentationMarker('commands', l:ftplugin_filename)
  endfor

endfunction

function! GenerateMissingDocumentationTags() abort
  " Want all actions to be carried out as single action, so user can undo with
  " single 'u' press, set has been editied as false
  let s:has_edited = v:false

  " Generate init.vi mappings
  call s:PrintMissingTags('init.vim', 'mappings')

  " Generate ftplugin mappings
  " So list ftplugin directory listings
  for full_ftplugin_path in split(globpath(g:autodoc_config_path . '/ftplugin', '*'), '\n')
    let l:ftplugin_filename = s:GenerateFtpluginFilename(full_ftplugin_path)

    call s:PrintMissingTags('ftplugin/' . l:ftplugin_filename, 'mappings')
  endfor

  " Generate init.vi commands
  call s:PrintMissingTags('init.vim', 'commands')

  " Generate ftplugin commands
  " So list ftplugin directory listings
  for full_ftplugin_path in split(globpath(g:autodoc_config_path . '/ftplugin', '**/*.vim'), '\n')
    let l:ftplugin_filename = substitute(full_ftplugin_path, g:autodoc_config_path . '/', '', '')

    call s:PrintMissingTags(l:ftplugin_filename, 'commands')
  endfor
endfunction

function! GenerateDocumentation() abort
  " Want all actions to be carried out as single action, so user can undo with
  " single 'u' press, set has been editied as false
  let s:has_edited = v:false

  " Generate init.vi mappings
  call s:PrintMappings('init.vim')

  " Generate ftplugin mappings
  " So list ftplugin directory listings
  for full_ftplugin_path in split(globpath(g:autodoc_config_path . '/ftplugin', '*'), '\n')
    let l:ftplugin_filename = s:GenerateFtpluginFilename(full_ftplugin_path)

    call s:PrintMappings('ftplugin/' . l:ftplugin_filename)
  endfor

  " Generate init.vi commands
  call s:PrintCommands('init.vim')

  " Generate ftplugin commands
  " So list ftplugin directory listings
  for full_ftplugin_path in split(globpath(g:autodoc_config_path . '/ftplugin', '**/*.vim'), '\n')
    let l:ftplugin_filename = substitute(full_ftplugin_path, g:autodoc_config_path . '/', '', '')

    call s:PrintCommands(l:ftplugin_filename)
  endfor
endfunction

function! s:GenerateFtpluginFilename(ftplugin_path) abort
    " if a filetype has a directory for grouping scripts etc, them just run
    " for the matching nested filetype.vim file
    let l:ftplugin_path_end = split(a:ftplugin_path, '/')[-1]
    if matchstr(l:ftplugin_path_end, '.*.vim$') ==? ''
      let l:ftplugin_path_end = l:ftplugin_path_end . '/' . l:ftplugin_path_end . '.vim'
    endif

    return l:ftplugin_path_end
endfunction

" Finds all mappings, and searches around them for a comment, printing
" all mappings along with comment out as a summary
" TODO this probably needs to capture ignorecase, smartcase and magic and then
" reset at end to handle sillyness? Need to test this
function! s:PopulateItemAndComments(filename, regex) abort
  " Reinitialise the mappings variables
  let s:mappings = {}
  let s:mapping_key_ordered = []

  let l:vim_path_filename = g:autodoc_config_path . '/' . a:filename
  " Capture current buffer to switch back to later
  let l:buf_name = expand("%")

  " Capture cursor position to be restored later with
  let [_, l:lnum, l:col, _] = getpos(".")

  try
    let l:filename_loaded = s:LoadHiddenBufferToSearch(l:vim_path_filename)
  catch
    echom v:exception
    break
  endtry

  " move to top of file
  call cursor(1,1)

  " This is a variable as needs to change after inition match
  let l:flags = "Wc" "'c' is required to include current/first line


  while search(a:regex, l:flags) != 0
    let l:found_item = s:GetItemWithComments()

    " Add key to ordered list
    call add(s:mapping_key_ordered, l:found_item[0])
    " Add result to overall dictionary
    let s:mappings[l:found_item[0]] = l:found_item[1]

    let l:flags = "W" "'c' need to remove c to prevent loop breakage
  endwhile

  call s:SwitchBackToOriginalBuffer(l:buf_name, l:vim_path_filename, l:filename_loaded, l:lnum, l:col)
endfunction

" Escapes forward slashed in path for global searching
function! s:EscapePath(string) abort
  return substitute(a:string, '/', '\\/', 'g')
endfunction

" Removes a documentation block
function! s:RemoveDocumentationBlockContents(type, string)
  let l:start_string = s:EscapePath(s:GetDocumentationBlockMarker(a:type, v:true, a:string))
  let l:end_string = s:EscapePath(s:GetDocumentationBlockMarker(a:type, v:false, a:string))

  silent! execute "g/^" . l:start_string . "/+1 ,/^" . l:end_string . "/-1 d"
  normal k
endfunction

" Returns string of start or end documentation block marker
function! s:GetDocumentationBlockMarker(type, isStart, filepath) abort
  if a:isStart
    return '<!-- start autodocumentation block ' . a:filepath . ' ' . a:type . ' -->'
  else
    return '<!-- end  autodocumentation block ' . a:filepath . ' ' . a:type . ' -->'
  endif
endfunction

" Puts either a start or end markdown comment for given string, these are used
" to find and replace existing auto documentation
" Only Prints if mappings or commands found
function! AddAutoDocumentationMarker(type, filepath) abort
    if a:type ==# 'mappings'
      call s:PopulateItemAndComments(a:filepath, s:find_mapping_regex)
      if len(s:mapping_key_ordered) == 0
        return
      endif
    else

      call s:PopulateItemAndComments(a:filepath, s:find_command_regex)

      if len(s:mapping_key_ordered) == 0
        return
      endif
    endif

    let l:lines = []
    call add(l:lines, s:GetDocumentationBlockMarker(a:type, v:true, a:filepath))
    call add(l:lines, s:GetDocumentationBlockMarker(a:type, v:false, a:filepath))
    call add(l:lines, '')
    call s:UndoableAppend('.', l:lines)
endfunction

" Function to append array to buffer, if edit has already occured then use,
" 'undojoin'
function! s:UndoableAppend(location, lines) abort
  if s:has_edited
    undojoin | call append(a:location, a:lines)
  else
    call append(a:location, a:lines)
    let s:has_edited = v:true
  endif
endfunction

" Echo's any markers that can't be found
function! s:PrintMissingTags(filename, type) abort
 " Capture cursor position to be restored later with
 let [_, l:lnum, l:col, _] = getpos(".")

  " Find mappings marker tags
  let l:doc_block_exists = search(s:GetDocumentationBlockMarker(a:type, v:true, a:filename))

  if l:doc_block_exists == 0
    call AddAutoDocumentationMarker(a:type, a:filename)
  endif

 " Restores cursor position
 call cursor(l:lnum, l:col)
endfunction

" This prints the found mappings to the buffer, note that as the start
" location is set and just using append to current line, it's printed
" backwards.
function! s:PrintMappings(filename) abort
  " Delete existing contents
  call s:RemoveDocumentationBlockContents('mappings', a:filename)

  " Find mappings marker
  let l:doc_block_exists = search(s:GetDocumentationBlockMarker('mappings', v:true, a:filename))

  if l:doc_block_exists > 0
    call s:PopulateItemAndComments(a:filename, s:find_mapping_regex)

    let l:lines = []
    if len(s:mapping_key_ordered) > 0
      if g:autodoc_table_show_action == v:true
        call add(l:lines, '| Mapmode | Mapping | Action | Description |')
        call add(l:lines, '| ------- | ------- | -------| ----------- |')
      else
        call add(l:lines, '| Mapmode | Mapping | Description |')
        call add(l:lines, '| ------- | ------- | ----------- |')
      endif
    endif

    " Want to display mappings with column for:
    " mapmode | mapping (includes if silent and/or expression) | RHS of mapping
    " Iterate through map and append to buffer
    for i in s:mapping_key_ordered
      " This is slightly odd as the RHS may have spaces within it, and the
      " mapping may include additional parts (i.e. silent or expression)
      let l:mapmode = split(i)[0]
      let l:lhs = matchstr(i, '\v.{-}\s(\<silent\>\s(\<expr\>)?)?.{-}\s')
      " substitute lhs using non-greedy regex upto and including first
      " whitespace, could just substitute mapmode with whitespace but... meh
      let l:mapping = substitute(l:lhs, '\v.{-}\s', '', '')
      " rhs is just original minus the lhs
      let l:rhs = substitute(i, l:lhs, '', '')

      " Markdown will process text in ` as code block and try to close "tags"
      " like <leader> so:
      let l:mapping = s:EscapeForMarkdown(l:mapping)
      let l:rhs = s:EscapeForMarkdown(l:rhs)

      " now print out all the parts in columns
      if g:autodoc_table_show_action == v:true
        call add(l:lines, '| ' . l:mapmode . ' | ' . l:mapping . ' | ' . l:rhs . ' | ' . s:mappings[i] . ' |')
      else
        call add(l:lines, '| ' . l:mapmode . ' | ' . l:mapping . ' | ' . s:mappings[i] . ' |')
      endif
    endfor

    if len(s:mapping_key_ordered) > 0
      call add(l:lines, '')
    endif
    call s:UndoableAppend('.', l:lines)
  else
    if g:autodoc_show_missing
      echom 'No marker found for: ' . a:filename
    endif
  endif
endfunction

" This prints the found commmands to the buffer
function! s:PrintCommands(filename) abort
  " Delete existing contents
  call s:RemoveDocumentationBlockContents('commands', a:filename)

  " Find mappings marker
  let l:doc_block_exists = search(s:GetDocumentationBlockMarker('commands', v:true, a:filename))

  if l:doc_block_exists > 0
    call s:PopulateItemAndComments(a:filename, '\v^command(!)?')

    " Want to display mappings with column for:
    " mapmode | mapping (includes if silent and/or expression) | RHS of mapping
    " Iterate through map and append to buffer
    let l:lines = []
    if len(s:mapping_key_ordered) > 0
      call add(l:lines, '| Command | Config | Description |')
      call add(l:lines, '| ------- | -------| ----------- |')
    endif

    for i in s:mapping_key_ordered
      " pointer it move through command parts, skip 'command' initial part
      " once the name is captured just escape
      let l:j = 1
      let l:end = v:false
      let l:command_part_list = split(i)
      let l:command_name = ''
      let l:command_flags = []
      while l:j < len(l:command_part_list) && !l:end
        let l:part = l:command_part_list[l:j]
        if l:part =~ '^-'
          call add(l:command_flags, l:part)
        else
          let l:command_name = l:part
          let l:end = v:true
        endif
        let l:j += 1
      endwhile

      " now print out all the parts in columns
      call add(l:lines, '| ' . l:command_name . ' | ' . join(l:command_flags) . ' | ' . s:mappings[i] . ' |')
    endfor

    if len(s:mapping_key_ordered) > 0
      call add(l:lines, '')
    endif
    call s:UndoableAppend('.', l:lines)
  else
    if g:autodoc_show_missing
      echom 'No marker found for: ' . a:filename
    endif
  endif
endfunction

" Escape string so that when displayed in markdown it displays as expected
function! s:EscapeForMarkdown(string) abort
  let l:expr = substitute(a:string, '<', '\\<', 'g')
  let l:expr = substitute(l:expr, '`', '\\`', 'g')
  return l:expr
endfunction

function! s:SwitchBackToOriginalBuffer(original_buffer, searched_buffer, delete_searched_buffer, cursor_line, cursor_column) abort
  " switch back to original buffer
  execute 'buffer ' . a:original_buffer
  " if buffer was not already loaded then delete it
  if !a:delete_searched_buffer
    execute 'bdelete ' . a:searched_buffer
  endif
  " Restores cursor position
  call cursor(a:cursor_line, a:cursor_column)
endfunction

function! s:LoadHiddenBufferToSearch(filename) abort
  " TODO something here isn't right with paths/expand...
  " capture if buffer already exists
  let l:filename_loaded = bufexists(expand(a:filename))
  " temporary switch to passed filename
  if filereadable(expand(a:filename))
    if l:filename_loaded
      execute 'noswapfile hide buffer ' . expand(a:filename)
      return v:true
    else
      execute 'noswapfile hide view ' . expand(a:filename)
    endif
  else
    throw "File does not exist"
  endif
  return v:false
endfunction

function! s:GetItemWithComments() abort
  " List to pass resultback in
  let l:item = []

  let l:matched_val = trim(getline("."))
  let l:matched_line_num = line(".")

  " Add item to items map with comments
  let l:item_comments = s:SearchForComments(l:matched_line_num)
  call add(item, l:matched_val)
  call add(item, l:item_comments)
  " echom 'item: ' . l:matched_val
  " echom 'comments: ' . l:item[l:matched_val]

  " Put cursor back to item match ready to find next item match
  call cursor(l:matched_line_num, 0)

  return l:item
endfunction

" TODO add check to see if a comment in on current line, if so return and
" don't look up
function! s:SearchForComments(start_line) abort
    " var to store comments in
    let l:item_comments = ''

    " now look for comments, looking up from current matched item
    let l:looking_for_comment = v:true
    let l:item_line_num = a:start_line

    " look backwards until line not a comment
    while l:item_line_num > 1 && l:looking_for_comment == v:true
      let l:item_line_num -= 1
      " Search for line that has optional whitespace before a comment, but
      " ignore any comments that are followed by a single whitespace and
      " opening or closing fold marks
      let l:is_comment = search('\v^(\s+)?"(\s\{\{\{)@!(\s\}\}\})@!', 'b', l:item_line_num)

      if l:is_comment > 0
        let l:item_comments = getline('.') . l:item_comments
      else
        " Stop looking
        let l:looking_for_comment = v:false
      endif
    endwhile

    return trim(substitute(l:item_comments, '"', '', 'g'))
endfunction
