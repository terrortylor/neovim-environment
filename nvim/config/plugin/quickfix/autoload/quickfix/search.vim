" Runs grep in sub shell, shows results in tabbed view with some additional
" mappings
function! quickfix#search#TabbedGrep(...) abort
  " Before running in a sub shell this was good as silent and did't open
  " quicklist
  " execute "silent! grep! " . expand(join(a:000, ' '))

  cgetexpr s:GrepInSubShell(join(a:000, ' '))
  call quickfix#tabbed#TabbedQuicklistViewer()
endfunction

" Runs grep in sub shell, and displays results in quickfix window
" silent result (i.e.  no press enter prompt) and does not show first match in
" current window
function! quickfix#search#SimpleGrep(...) abort
  cgetexpr s:GrepInSubShell(join(a:000, ' '))
  copen
endfunction

" Takes insiration from this gist: https://gist.github.com/romainl/56f0c28ef953ffc157f36cc495947ab3
function! s:GrepInSubShell(...) abort
  return system(join([&grepprg] + [expand(join(a:000, ' '))], ' '))
endfunction
