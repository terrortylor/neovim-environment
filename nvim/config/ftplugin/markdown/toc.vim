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
  if getline(line(0)) == ""
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
    let a:padding = repeat(" ", 2 * a:heading_level)
    " insert toc line, numbered lists just need to be a number... makes it
    " easier :P
    call append(a:line, a:padding . "1." . a:heading_text)
    let a:line += 1
  endfor

  " add a comment line that will be used to mark end of TOC
  call append(a:line, s:toc_end_marker)
endfunction

function! CreateTOC()
  " move to top of file
  call cursor(1,1)

  let s:found_headings = []

  call s:RemoveTOC()

  call s:GetHeaders()

  call s:WriteTOC()
endfunction
