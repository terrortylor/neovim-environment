let s:cpo_save = &cpo
set cpo&vim
" pppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp

" Stores the current state
if !exists('s:hidden_all')
 let s:hidden_all = 0
endif

" Stores 'noise' settings
if !exists('s:saved_settings')
  let s:saved_settings = {}
endif

if !exists('s:non_text_hlg')
 let s:non_text_hlg = {}
endif

" List of settings to disable
if !exists('s:hide_settings')
 let s:hide_settings = ['showmode', 'ruler', 'number', 'relativenumber', 'showcmd']
endif

function! s:SaveSetting(setting_name)
  execute 'let s:saved_settings[a:setting_name] = &'.a:setting_name
endfunction

function! s:SetSetting(setting_name)
  if has_key(s:saved_settings, a:setting_name)
    execute 'let &'.a:setting_name.' = get(s:saved_settings, a:setting_name)'
  else
    echom "No setting value found for: " . a:setting_name
  endif
endfunction

function! PrintSettings()
  echom "Debug Print Settings:"
  echom "Hide Mode: " . s:hidden_all
  for option in keys(s:saved_settings)
    echom option . " : " . get(s:saved_settings, option)
  endfor
endfunction

function! HideNoiseToggle() abort
  if s:hidden_all==0
    let s:hidden_all = 1

    call s:SaveSetting("showmode")
    setlocal noshowmode

    call s:SaveSetting("ruler")
    setlocal noruler

    call s:SaveSetting("laststatus")
    set laststatus=0

    call s:SaveSetting("showtabline")
    set showtabline=0

    call s:SaveSetting("showcmd")
    setlocal noshowcmd

    call s:SaveSetting("number")
    setlocal nonumber

    call s:SaveSetting("relativenumber")
    setlocal norelativenumber

    let s:non_text_hlg['ctermfg'] = s:Return_Highlight_Term('NonText', 'ctermfg')
    let s:non_text_hlg['guifg'] = s:Return_Highlight_Term('NonText', 'guifg')
    highlight NonText ctermfg=bg guifg=bg
  else
    let l:this_tab = tabpagenr()
    if l:this_tab == s:focus_tab
      let s:hidden_all = 0

      call s:SetSetting('showmode')
      call s:SetSetting('ruler')
      call s:SetSetting('laststatus')
      call s:SetSetting('showtabline')
      call s:SetSetting('showcmd')
      call s:SetSetting('number')
      call s:SetSetting('relativenumber')

      let s:saved_settings = {}

      let s:focus_tab=''

      execute 'highlight NonText ctermfg=' . s:non_text_hlg['ctermfg'] . ' guifg=' . s:non_text_hlg['guifg']
      let s:non_text_hlg = {}
    endif
  endif
endfunction

function! s:Return_Highlight_Term(group, term)
   " Store output of group to variable
   let a:output = execute('hi ' . a:group)

   " Find the term we're looking for
   return matchstr(a:output, a:term .'=\zs\S*')
endfunction

function! s:Init_Padding_Window(command)
  execute a:command

  " Make the new window blank/scratch
  setlocal buftype=nofile bufhidden=wipe nomodifiable nobuflisted noswapfile
    \ nonumber norelativenumber
    \ nocursorline nocursorcolumn winfixwidth winfixheight
    \ statusline=\

  " return the window id for resizing later
  return win_getid()
endfunction

function! s:Resize_Windows()
  let l:width = &columns
  let l:buf_win_width = (l:width - 100) / 2

  " Set left padding
  let l:win_id = t:padding_windows.left
  call win_gotoid(l:win_id)
  execute 'vertical resize ' . l:buf_win_width

  " Set right padding
  let l:win = bufwinnr(t:padding_windows.right)
  call win_gotoid(l:win_id)
  execute 'vertical resize ' . l:buf_win_width
endfunction

function! s:ManageHeaderFooter()
  let l:this_tab = tabpagenr()
  if l:this_tab == s:focus_tab
    set laststatus=0
    set showtabline=0
    highlight NonText ctermfg=bg guifg=bg
  else
    execute 'let &laststatus = get(s:saved_settings, "laststatus")'
    execute 'let &showtabline = get(s:saved_settings, "showtabline")'
    execute 'highlight NonText ctermfg=' . s:non_text_hlg['ctermfg'] . ' guifg=' . s:non_text_hlg['guifg']
  endif
endfunction

" TODO rename to Focus and have have a cleanup function called when leave
" buffer/new window etc
function! FocusToggle() abort

  " Create a new tab and empty buffer each side as 'buffers'
  tab split
  let t:focus_window = win_getid()
  let t:padding_windows = {}
  let t:padding_windows.left = s:Init_Padding_Window('vertical topleft new')
  let t:padding_windows.right = s:Init_Padding_Window('vertical botright new')
  " Capture tab for status bar management
  let s:focus_tab = tabpagenr()

  call s:Resize_Windows()

  " move back to buffer to edit
  call win_gotoid(t:focus_window)

  " Hide noise
  call HideNoiseToggle()


  " Setup autogroup to handle moving in/out of focus tab
  augroup focusgroup
    autocmd!
    autocmd TabEnter,TabLeave * nested call s:ManageHeaderFooter()
    autocmd TabClosed * nested call HideNoiseToggle()
  augroup END
endfunction

command! Focus call FocusToggle()

let &cpo = s:cpo_save
unlet s:cpo_save
