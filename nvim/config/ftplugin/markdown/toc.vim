" Adds a markdown style TOC to the top of the markdown file
command! -nargs=0 CreateTOC call CreateTOC()

" Removes a markdown style TOC from the top of the markdown file
command! -nargs=0 RemoveTOC call RemoveTOC()

let s:toc_title = "# Table of contents"
let s:toc_end_marker = "<!--- end of toc -->"

function! s:GetHeaders()
  let a:flags = "Wc" "'c' is required to include current/first line
  while search("^##", a:flags) != 0
    let l:line = getline(".")
    let s:found_headings = add(s:found_headings, l:line)
    let a:flags = "W" "'c' need to remove c to prevent loop breakage
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
  let a:line = 2
  for heading in s:found_headings
    " Get #'s
    let a:hashes = substitute(heading, "[^#]", "","g")
    " Get rest of heading title
    let a:heading_text = substitute(heading, "[#]", "","g")
    " Work out heading title for padding
    let a:heading_level = len(a:hashes) - 2
    if a:heading_level > 0
      let a:padding = repeat(" ", 3 * a:heading_level)
    else
      let a:padding = ""
    endif
    " format heading link
    let a:heading_link = "[" . trim(a:heading_text) . "](#" . substitute(trim(a:heading_text), " ", "_", "g") . ")"
    " insert toc line, numbered lists just need to be a number... makes it
    " easier :P
    call append(a:line, a:padding . "1. " . a:heading_link)
    let a:line += 1
  endfor

  " add a comment line that will be used to mark end of TOC
  call append(a:line, s:toc_end_marker)
endfunction

function! CreateTOC()
  "TODO set a mark to return to at the end of this function, it should store
  "the mark incase user is using it and restore that too.

  " move to top of file
  call cursor(1,1)

  let s:found_headings = []

  call s:RemoveTOC()

  call s:GetHeaders()

  call s:WriteTOC()
endfunction
