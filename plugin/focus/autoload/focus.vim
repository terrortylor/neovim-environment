" TODO manage some way of if window is closed
" TODO reread and refactor
" TODO have global var for background colour if NORMAL group background colour is not set

" Stores 'noise' settings
if !exists('s:saved_settings')
  let s:saved_settings = {}
endif

if !exists('s:saved_highlight_groups')
 let s:saved_highlight_groups = {}
endif

" List of settings to disable
if !exists('s:hide_settings')
 let s:hide_settings = ['showmode', 'ruler', 'number', 'relativenumber', 'showcmd', 'laststatus', 'showtabline']
endif

" List of highlight groups to change
if !exists('s:hide_highlight_groups')
  let s:hide_highlight_groups = ['NonText', 'FoldColumn', 'ColorColumn', 'VertSplit', 'SignColumn']
endif

function! s:SaveSetting(setting_name)
  execute 'let s:saved_settings[a:setting_name] = &'.a:setting_name
endfunction

function! s:RestoreSetting(setting_name)
  if has_key(s:saved_settings, a:setting_name)
    execute 'let &'.a:setting_name.' = get(s:saved_settings, a:setting_name)'
  endif
endfunction

function! s:SaveHighlightGroup(group) abort
  let l:highlight_group = {}
  let l:highlight_group['fg'] = s:GetHighlightTermColour(a:group, 'fg')
  let l:highlight_group['bg'] = s:GetHighlightTermColour(a:group, 'bg')
  let s:saved_highlight_groups[a:group] = l:highlight_group
endfunction

function! s:RestoreHighlightGroup(group) abort
  if has_key(s:saved_highlight_groups, a:group)
    let l:highlight_group = s:saved_highlight_groups[a:group]
      call s:SetHighlightTermColour(a:group, 'fg', l:highlight_group['fg'])
      call s:SetHighlightTermColour(a:group, 'bg', l:highlight_group['bg'])
  endif
endfunction

function! s:SetHighlightTermColour(group, term, colour)
  let gui = &termguicolors ? 'gui' : 'cterm'
  if empty(a:colour)
    let l:checked_colour = 'NONE'
  else
    let l:checked_colour = a:colour
  endif
  execute 'highlight ' . a:group . ' ' . l:gui . a:term . '=' . l:checked_colour
endfunction

" This returns the colour code for the group/term supplied, this is based on
" either cterm/gui is returned based on what the user has set
function! s:GetHighlightTermColour(group, term)
   " " Store output of group to variable
   " let l:output = execute('hi ' . a:group)

   " " Find the term we're looking for
   " return matchstr(l:output, a:term .'=\zs\S*')
   return synIDattr(synIDtrans(hlID(a:group)), a:term)
endfunction

" This is a toggle function used to configure a tab so that 'noise' is removed
" Where ever possible it uses local settings, some settings are can not be
" local and so they are also managed via the s:ManageHeaderFooter function
function! s:HideNoiseToggle() abort
    let l:this_tab = tabpagenr()
    if l:this_tab == s:focus_tab
      " Capture settings to override
      for i in s:hide_settings
        call s:SaveSetting(i)
      endfor

      " Override settings
      setlocal noshowmode
      setlocal noruler
      set laststatus=0
      set showtabline=0
      setlocal noshowcmd
      setlocal nonumber
      setlocal norelativenumber

      " Capture 'Normal' group's background to apply to other groups
      " FIXME if 'Normal' group not set background colour then use plugin default?
      " Is this edge case? as usually colour scheme has this set?
      let l:background_bg = s:GetHighlightTermColour('Normal', 'bg')

      " Apply Normal's background to highilght groups to 'hide' them
      let l:highlight_groups = s:hide_highlight_groups
      for i in l:highlight_groups
        call s:SaveHighlightGroup(i)
        call s:SetHighlightTermColour(i, 'fg', l:background_bg)
        call s:SetHighlightTermColour(i, 'bg', l:background_bg)
      endfor
  else
      " Restore settings
      for i in s:hide_settings
        call s:RestoreSetting(i)
      endfor

      " Restore highilght groups to 'show' them
      let l:highlight_groups = s:hide_highlight_groups
      for i in l:highlight_groups
        call s:RestoreHighlightGroup(i)
      endfor
    endif
endfunction

function! s:InitPaddingWindow(command)
  execute a:command

  " Make the new window blank/scratch
  setlocal buftype=nofile bufhidden=wipe nomodifiable nobuflisted noswapfile
    \ statusline=\  nonumber norelativenumber
    \ nocursorline nocursorcolumn winfixwidth winfixheight

  " return the window id for resizing later
  return win_getid()
endfunction

function! s:ResizeWindows()
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

function! FocusBuffer() abort
  " Quick Sanity check to make sure not in focused buffer view
  if exists('s:focus_tab')
    let l:this_tab = tabpagenr()
    if l:this_tab == s:focus_tab
      return
    endif
  endif

  " If focus already running load current buffer in that tab
  if exists('s:focus_tab')
    " FocusBuffer already running so catpture buffer number
    let l:buf_nr = bufnr("%")
    call win_gotoid(s:focus_window)
    execute ':buffer ' . l:buf_nr
  else
    " Create a new tab and empty buffer each side as 'padding'
    tab split
    let s:focus_window = win_getid()
    let t:padding_windows = {}
    let t:padding_windows.left = s:InitPaddingWindow('vertical topleft new')
    let t:padding_windows.right = s:InitPaddingWindow('vertical botright new')
    " TODO add top and bottom?? Make configurable hight
    " Capture tab for status bar management
    let s:focus_tab = tabpagenr()

    call s:ResizeWindows()

    " move back to buffer to edit
    call win_gotoid(s:focus_window)

    " Hide noise
    call s:HideNoiseToggle()

    " Setup autogroup to handle moving in/out of focus tab
    augroup focus_group
      autocmd!
      autocmd TabEnter * nested call s:HideNoiseToggle()
      autocmd TabClosed * nested call s:Cleanup()
    augroup END
  endif
endfunction

function! s:Cleanup() abort
  let l:this_tab = tabpagenr()
  if l:this_tab != s:focus_tab
    call s:HideNoiseToggle()
    augroup focus_group
      autocmd!
    augroup END
    augroup! focus_group

    " Clear saved settings
    let s:saved_settings = {}

    " unlet script variables
    unlet s:focus_tab
    unlet s:focus_window
  endif
endfunction
