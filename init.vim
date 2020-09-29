lua require 'config'

" Override fold highlighting
augroup vimrc_highlight_overrides
  autocmd!
  " TODO choose better colours
  autocmd ColorScheme * highlight Folded guifg=56 guibg=215
augroup END

  " custom file specific folding overrides
augroup custom_file_folding
  autocmd!
  autocmd BufRead,BufWinEnter init.vim setlocal
    \ foldmethod=marker
    \ foldenable
    \ fillchars=fold:\  foldtext=MyVimrcFoldText()
    \ foldtext=MyVimrcFoldText()
augroup END

" {{{ test fold
" some stuff goes here
" }}} test fold

function! MyVimrcFoldText()
    let line = getline(v:foldstart)
    let spaces = substitute(line, '\v^(\s*)"\s+\{.*', '\1', 'g')
    let line_text = substitute(line, '\v^\s*"\s+\{+', '', 'g')
    let foldtext = spaces . '-' . line_text
    return foldtext
endfunction

call pluginman#CacheInstalledPlugins()

let opts = {'load': 'opt'}
call pluginman#AddPlugin('https://github.com/godlygeek/tabular', opts)
" InstallPlugin https://github.com/godlygeek/tabular opts
packadd tabular

" tabular needs to be sourced before vim-markdown
" according to the repository site
let opts = {'load': 'opt'}
call pluginman#AddPlugin('https://github.com/plasticboy/vim-markdown', opts)
packadd vim-markdown

" Don't require .md extension
let g:vim_markdown_no_extensions_in_markdown = 1

" Autosave when following links
let g:vim_markdown_autowrite = 1

function! QuickfixMappings() abort
  nmap <leader>ce <Plug>(QuicklistCreateEditableBuffer)
  nmap <leader>cs <Plug>(QuickfixCreateFromBuffer)
  nmap <leader>ca <Plug>(QuickfixApplyLineChanges)

  nnoremap [C :colder<cr>
  nnoremap ]C :cnewer<cr>
endfunction

augroup quickfix_mappings
  autocmd!
  " autocmd BufReadPost quickfix nested :call QuickfixMappings()
  autocmd WinEnter * if &buftype == 'quickfix' | call QuickfixMappings() | endif
augroup END

" Custom global search within buffer, displays results in location list
" just clears it self
nnoremap <leader>fb :FindInBuffer
" Custom global search within buffer using selection, displays results in location list
vnoremap <leader>fb y:FindInBuffer <c-r>"
" Custom Grep (tabbed view) for selection within current directory, path can
" be added
vnoremap <leader>ftp y:Grep <c-r>"
" Custom Grep (tabbed view) within current directory, path can
" be added
nnoremap <leader>ftp :Grep
" Custom Grep for selection within current directory with standard quickfix
" window, path can be added
vnoremap <leader>fp y:SimpleGrep <c-r>"
" Custom Grep within current directory with standard quickfix
" window, path can be added
nnoremap <leader>fp y:SimpleGrep

InstallPlugin https://github.com/justinmk/vim-sneak
" There is some remapping of 's' to '<space>s' see after/plugin/vim-sneak.vim

InstallPlugin https://github.com/preservim/nerdtree

" Open NERDTree at current file location, close if open
" Takes into account in a buffer is loaded or not
function! NerdToggleFind()
  if exists("g:NERDTree")
    " If no buffer has been loaded
    if @% == ""
      NERDTreeToggle
    else
      " if nerdtree is open
      if g:NERDTree.IsOpen()
        " if nerdtree focused then close
        if bufwinnr(t:NERDTreeBufName) == winnr()
          NERDTreeToggle
        else
          NERDTreeFind
        endif
      else
        NERDTreeFind
      endif
    endif
  endif
endfunction

InstallPlugin https://github.com/ctrlpvim/ctrlp.vim
InstallPlugin https://github.com/tacahiroy/ctrlp-funky

" Fuzzy find open buffers
nnoremap <leader><space>  :<C-u>CtrlPBuffer<CR>
" Fuzzy find functions in project
nnoremap <leader>ff  :<C-u>CtrlPFunky<CR>
" Fuzzy find and jump to marks
nnoremap <leader>fm  :<C-u>CtrlPMarks<CR>
" Fuzy find and insert contents of register
nnoremap <leader>fr  :<C-u>CtrlPRegister<CR>
" Fuzzy find and start Ultisnips snippet
nnoremap <leader>fu  :<C-u>CtrlPUltisnips<CR>

let g:ctrlp_extensions = ['marks']

let opts = {'load': 'opt'}
call pluginman#AddPlugin('https://github.com/SirVer/ultisnips', opts)

if has("python3")
  packadd! ultisnips

  nnoremap <leader>ue :UltiSnipsEdit<CR>:set filetype=snippets<CR>

  " TODO this is apparently supported OOTB
  augroup auto_reload_snippets_after_write
    autocmd!
    autocmd BufWritePost *.snippets :call UltiSnips#RefreshSnippets()
  augroup END
endif


InstallPlugin https://github.com/fatih/vim-go
InstallPlugin https://github.com/ludovicchabant/vim-gutentags
InstallPlugin https://github.com/christoomey/vim-tmux-navigator

" TODO have a think about this plugin, overlaps with TMUX one
" " Run buffer in REPL
" nnoremap <leader>rr :<C-u>TerminalReplFile<cr>
" " Toggle REPL Terminal
" nnoremap <leader>tr :<C-u>TerminalReplFileToggle<cr>

InstallPlugin https://github.com/junegunn/rainbow_parentheses.vim

augroup enable_rainbow_on_vim_enter
  autocmd!
  autocmd VimEnter * RainbowParentheses
augroup END
let g:rainbow#pairs = [['(', ')'], ['[', ']'], ['{', '}']]


" Open lazy git in throw away popup window
" TODO problem about this is it uses <space> to stage/unstage a file which
" is leader so either pause, or hit <CR> but that goes into stage view so
" have to hit <ESC>
" SEE HERE: https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md
" Mapping file needs to be persisted to ansible
command! -nargs=0 Lazygit call helper#float#SingleUseTerminal('lazygit')
nnoremap <leader>lg :<CR>
" }}} git

InstallPlugin https://github.com/tpope/vim-commentary
InstallPlugin https://github.com/jacoborus/tender.vim
colorscheme tender
InstallPlugin https://github.com/udalov/kotlin-vim
InstallPlugin https://github.com/machakann/vim-sandwich
InstallPlugin https://github.com/PProvost/vim-ps1

" Delete cached installed plugin list
call pluginman#DeleteCacheInstalledPlugins()
" TODO need to fix up toggle help file
" helptags ALL

" Opens first non empty list, location list is local to window
nnoremap <leader>cl :call quickfix#window#OpenList()<CR>
" Close all quicklist windows
nnoremap <leader>cc :call quickfix#window#CloseAll()<CR>
"
" To quickly go through the Quicklist
nnoremap ]c :cnext<CR>
nnoremap [c :cprevious<CR>

" Taken from: https://stackoverflow.com/questions/1444322/how-can-i-close-a-buffer-without-closing-the-window/44950143#44950143
func! DeleteCurBufferNotCloseWindow() abort
  if &modified
    echohl ErrorMsg
    echom "E89: no write since last change"
    echohl None
  elseif winnr('$') == 1
    bd
  else  " multiple window
    let oldbuf = bufnr('%')
    let oldwin = winnr()
    while 1   " all windows that display oldbuf will remain open
      if buflisted(bufnr('#'))
        b#
      else
        bn
        let curbuf = bufnr('%')
        if curbuf == oldbuf
          enew    " oldbuf is the only buffer, create one
        endif
      endif
      let win = bufwinnr(oldbuf)
      if win == -1
        break
      else        " there are other window that display oldbuf
        exec win 'wincmd w'
      endif
    endwhile
    " delete oldbuf and restore window to oldwin
    exec oldbuf 'bd'
    exec oldwin 'wincmd w'
  endif
endfunc

" Source shared vim config
augroup auto_load_vimrc_on_write
  autocmd!
  autocmd BufWritePost init.vim :source %
        \ | echo "vimrc sourced mother licker"
augroup END


" Show highlight group under cursor
" https://stackoverflow.com/questions/9464844/how-to-get-group-name-of-highlighting-under-cursor-in-vim
function! SynGroup()
    let l:s = synID(line('.'), col('.'), 1)
    echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfun
