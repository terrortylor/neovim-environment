" TODO if heading has charecters like /. etc then strip them out for links
" Adds a markdown style TOC to the top of the markdown file
command! -nargs=0 CreateTOC call CreateTOC()

" Removes a markdown style TOC from the top of the markdown file
command! -nargs=0 RemoveTOC call RemoveTOC()

let s:toc_title = "# Table of contents"
let s:toc_end_marker = "<!--- end of toc -->"

" TODO this doesn't take into account a section, i.e. does not end with #'s
function! s:GetHeaders()
  let l:flags = "Wc" "'c' is required to include current/first line
  while search("^##", l:flags) != 0
    let l:line = getline(".")
    let s:found_headings = add(s:found_headings, l:line)
    let l:flags = "W" "'c' need to remove c to prevent loop breakage
  endwhile
endfunction

function! s:RemoveTOC()
  execute "g/^" . s:toc_title . "/,/^" . s:toc_end_marker . "/d"
  " Bit of a hack as gerex wans't coming back as true/false
  " so just see if there is a match for whitespace
  if match(getline(1), '\S')
    call cursor(1,1)
    delete
  endif
endfunction

function! s:WriteTOC()
  call append(0, '')
  call append(0, s:toc_title)
  call append(1, '')
  let l:line = 2
  for heading in s:found_headings
    " Get #'s
    let l:hashes = substitute(heading, "[^#]", "","g")
    " Get rest of heading title
    let l:heading_text = substitute(heading, "[#]", "","g")
    " Work out heading title for padding
    let l:heading_level = len(l:hashes) - 2
    if l:heading_level > 0
      let l:padding = repeat(" ", 3 * l:heading_level)
    else
      let l:padding = ""
    endif
    " format heading link
    let l:heading_link = "[" . trim(l:heading_text) . "](#" . substitute(tolower(trim(l:heading_text)), " ", "-", "g") . ")"
    " insert toc line, numbered lists just need to be a number... makes it
    " easier :P
    call append(l:line, l:padding . "1. " . l:heading_link)
    let l:line += 1
  endfor

  " add a comment line that will be used to mark end of TOC
  call append(l:line, s:toc_end_marker)
endfunction

function! CreateTOC()
  let l:old_reg = getreg("a")
  let l:old_reg_type = getregtype("a")
  normal ma

  " move to top of file
  call cursor(1,1)

  let s:found_headings = []

  call s:RemoveTOC()

  call s:GetHeaders()

  call s:WriteTOC()

  normal `a
  call setreg("a", l:old_reg, l:old_reg_type)
endfunction
