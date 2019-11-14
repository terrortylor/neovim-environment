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

function! PringSettings()
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
    set noshowmode

    call s:SaveSetting("ruler")
    set noruler

    call s:SaveSetting("laststatus")
    set laststatus=0

    call s:SaveSetting("showcmd")
    set noshowcmd

    call s:SaveSetting("number")
    set nonumber

    call s:SaveSetting("relativenumber")
    set norelativenumber
  else
    let s:hidden_all = 0

    call s:SetSetting('showmode')
    call s:SetSetting('ruler')
    call s:SetSetting('laststatus')
    call s:SetSetting('showcmd')
    call s:SetSetting('number')
    call s:SetSetting('relativenumber')
  endif
endfunction

function! FocusToggle() abort
  let width = &columns
  echo "width : " . width
  let buf_win_width = (width - 100) / 2
  echo "buf win : " . buf_win_width

  " Create a new tab and empty buffer each side as 'buffers'
  tabedit %
  vnew
  wincmd H
  wincmd l
  vnew
  wincmd h
  wincmd h

  " size 'buffers'
  execute 'vertical resize ' . buf_win_width
  wincmd l
  vertical resize 100
endfunction

let &cpo = s:cpo_save
unlet s:cpo_save
