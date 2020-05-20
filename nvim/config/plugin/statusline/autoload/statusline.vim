" TODO rather than if/else nest mess here, have a function that is called in
" each atom that gives 'atom' name and some detials like, buftype or winnr (to
" work out what is required) and return true/false to display based on map...
" could work for what to display in window based on width
" TODO if window isn't wide enough then status line gets messed up
" understandably, look at prioritising atoms
function! statusline#update() abort
  for nr in range(1, winnr('$'))
    call setwinvar(nr, '&statusline', '%!statusline#build(' . nr . ')')
  endfor
endfunction

function! statusline#build(winnr) abort
  let l:statusline='%#AtomStatusLine#'

  " Got to capture some window /  buffer info so displays correctly for each
  " buffer
  let l:active = a:winnr == winnr()
  if active == 1 || g:statusline_show_inactive == v:true && active == 0
    let l:bufnr = winbufnr(a:winnr)
    let l:type = getbufvar(l:bufnr, '&buftype')

    " If not quickfix or help etc then show all the gubbins
    if l:type ==# ''
      " Editing buffer so give some details left hand side
      let l:statusline.=statusline#atoms#mode(active)
      let l:statusline.=statusline#atoms#git_branch()
      let l:statusline.=' '
      let l:statusline.=statusline#atoms#filename()
      let l:statusline.=statusline#atoms#modified()
      let l:statusline.=statusline#atoms#readonly(a:winnr)
      let l:statusline.=statusline#atoms#coc_function()
    else
      let l:statusline.=statusline#atoms#non_modifiable(l:type)
      let l:statusline.=' '
      if l:type !=# 'quickfix'
        let l:statusline.=statusline#atoms#filename()
        let l:statusline.=' '
      endif
      let l:statusline.=statusline#atoms#readonly(a:winnr)
    endif

    " Right hand side
    let l:statusline.='%='

    " If not quickfix or help etc then show all the gubbins
    if l:type ==# ''
      let l:statusline.=statusline#atoms#coc_diagnostics()
      let l:statusline.=statusline#atoms#case_sensitivity()
      let l:statusline.=' '
      let l:statusline.=statusline#atoms#filetype(a:winnr)
      let l:statusline.=' '
    endif
    let l:statusline.=statusline#atoms#location()
  else
    let l:statusline.=' '
    let l:statusline.=statusline#atoms#filename()
  endif
  return statusline
endfunction
