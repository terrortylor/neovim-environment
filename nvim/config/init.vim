filetype plugin indent on

" This file uses folding to better organise:
 " :help fold-commands
" {{{ VIM Settings
" {{{ leader
let mapleader = "\<Space>"
" }}} leader
" {{{ Theme
set background=dark
set termguicolors
colorscheme tender
" Note lightline status bar colour scheme is defined in plugin config bellow
" }}} Theme Leave
" {{{ Swap, Backup and Undo File Location
set backupdir=~/.config/nvim/backup//
set directory=~/.config/nvim/swap//
set undodir=~/.config/nvim/undo//

set undofile
" }}} Swap, Backup and Undo File Location
" {{{ Setup folding rules
" Global to indent, and not close them by default
set foldmethod=indent
set nofoldenable

" vi file folding overrides
augroup foldgroup
  autocmd!
  autocmd BufRead,BufNewFile init.vim setl foldmethod=marker foldenable
  " autocmd FileType vim setl foldmethod=marker foldenable
  autocmd FileType tmux setl foldmethod=marker foldenable
augroup END

" }}} VIM Settings
" {{{ General Settings
" don't bother about trying to support older versions
" set nocompatible

" Allow switching buffers without saving
set hidden

" Put curor in same place when re-open a file
augroup vim-on-open
  autocmd!
  autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \     execute 'normal! g`"zvzz' |
        \ endif
augroup END
" }}} General Settings
" {{{ Spelling
" Toggle spell checking
nnoremap <leader>s :set spell!<CR>
" disable spell checking on start but set language
set nospell spelllang=en_gb
" }}} Spelling
" {{{ Indentation Configure indentation to spaces of width 2
" https://stackoverflow.com/questions/1878974/redefine-tab-as-4-spaces
set tabstop=2 softtabstop=0 expandtab shiftwidth=2 smarttab

augroup fileindentgroup
  autocmd!
  autocmd FileType ruby setl expandtab
augroup END
" Autoindent from previous line
" Note that this seems to be on in neovim
set autoindent
" }}} Indentation
" {{{ Window behaviour
" Scroll before reaching the start/end of file
set scrolloff=5
" Open splits to the right and bellow
set splitright
set splitbelow
" }}} Window  behaviour
" {{{ Searching for files

" Show file options above the command line, in a more bash list way
" matching on full/longest
set wildmode=list,longest
set wildignorecase

set path+=**
" Fine tune to ignore file types
set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png,*.ico
set wildignore+=*.pdf,*.psd
set wildignore+=node_modules/*,bower_components/*
set wildignore+=bin/*,tags,*.session

" `gf` opens file under cursor in a new vertical split
" See this page on notes on autochdir: https://gist.github.com/csswizardry/9a33342dace4786a9fee35c73fa5deeb
nnoremap gf :vertical wincmd f<CR>

" }}} Searching for file close
" {{{ Visual Settings

" Always show the tab line
set showtabline=2

" See: https://vim.fandom.com/wiki/Display_line_numbers
" show current line number and relative line numbers
set number relativenumber!

" toggle relative number
nnoremap <leader>rln :set relativenumber!<CR>

" " Always showstatus bar
" Currently not using this in favoure of a plugin
" set laststatus=2
" " Format the status line
" set statusline=%f       "Path of the file
" set statusline+=%=      "left/right separator
" set statusline+=[%{strlen(&fenc)?&fenc:'none'}, "file encoding
" set statusline+=%{&ff}] "file format
" set statusline+=%h      "help file flag
" set statusline+=%m      "modified flag
" set statusline+=%r      "read only flag
" set statusline+=%y      "filetype
" set statusline+=%3c,     "cursor column
" set statusline+=%4l/%L   "cursor line/total lines
" set statusline+=\ %P    "percent through file

" Highlight current cursor line
set cursorline
" Toggle on and off as entering/leaving windows
augroup cursorlinegroup
  autocmd!
  autocmd WinEnter * setlocal cursorline
  autocmd WinLeave * setlocal nocursorline
augroup END
" }}} Visual Settings
" {{{ Buffer auto load / save
" autosave buffers when switching between then
set autowrite

" Auto load changes from the filesytem
set autoread

" Auto remove trailing whitespace on :w
augroup writebuffgroup
  autocmd!
  autocmd BufWritePre * %s/\s\+$//e
augroup END
" }}} Buffer auto load / save
" {{{ Searching within a buffer behaviour

" Set searching to only use case when an uppercase is used
" set ignorecase
" set smartcase

" Highlight search
set incsearch
set showmatch
set hlsearch

" This is neovim specific, makes live s/ changes in buffer
set inccommand=nosplit

" Set global flag on for search are replace
" :help gdefault
set gdefault

" Search and replace word under cursor
nnoremap <leader>r :%s/<c-r><c-w>//<left>

" turns of highlighting
nnoremap <leader>/ :noh<CR>

" Create command for global search in projct
command! -nargs=1 GGrep vimgrep "<args>" **/*
" }}} Searching within a buffer behaviour
" {{{ Searching
if executable('ack')
  set grepprg=ack\ -H\ --column\ --nofilter\ --nocolor\ --nogroup
endif
" }}} Searching
" {{{ Syntax Highlighting
" enable syntax highlighting
syntax enable

filetype plugin on

" Force syntax high lighting to sync from start of file
" as syntax highlighting gets messed up when scrolling larger files
syn sync fromstart
syn sync minlines=20
" }}} Syntax Highlighting
" {{{ Registers
"Map primary (*) clipboard
noremap <Leader>y "*y
noremap <Leader>p "*p
" Map clipboard (+)
noremap <Leader>Y "+y
noremap <Leader>P "+p
" }}} Registers
" {{{ Tags
set tags=./.git/tags;/
" }}} Tags
" }}} VIM Settings
" {{{ Plugin Settings
" {{{ vim-sneak
" There is some remapping of 's' to '<space>s' see after/plugin/vim-sneak.vim
" }}}
" {{{ NERDTree
nnoremap <space>f :<C-u>call NerdToggleFind()<CR>

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

" Autoclose vim if only NERDTree open
augroup nerdtreegroup
  autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
augroup END
" Show hidden files
let NERDTreeShowHidden=1
" Close after opening a file/bookmark
" try to force me to use go/gi for preview
let NERDTreeQuitOnOpen=3
" }}} NERDTree
" {{{ CtrlP
" Jump to open buffer if open:
let g:ctrlp_switch_buffer = 'Et'

" Current Buffers
nnoremap <space><space>  :<C-u>CtrlPBuffer<CR>
" }}} CtrlP
" {{{ netrw
" Configure netrw plugin to show file ls details
" See: https://shapeshed.com/vim-netrw/
let g:netrw_liststyle = 3
"
" Hide noisey banner
let g:netrw_banner = 0

" Open new tab in explorer
nnoremap <leader>E :Texplore<CR>
" }}} netrw
" {{{ ultisnips
if has("python3")
  " Ultisnips is used as it's fiarly light weight and is jsut the engine.
  " Note that if COC is running then these two keybinigs are disabled in
  " favour of <CR>
  let g:UltiSnipsExpandTrigger = '<tab>'
  let g:UltiSnipsListSnippets  = '<c-tab>'


  " As using COC tab and shift tab feel more natural
  " let g:UltiSnipsJumpForwardTrigger = '<c-j>'
  " let g:UltiSnipsJumpBackwardTrigger = '<c-k>'
  let g:UltiSnipsJumpForwardTrigger = '<TAB>'
  let g:UltiSnipsJumpBackwardTrigger = '<S-TAB>'

  " This just sets the path of where we edit/create personnal snippets
  let g:UltiSnipsSnippetsDir=$HOME . "/.config/nvim/ultisnips"
  " But the engine that loads the snippets for runtime
  " load from neovim's runtimepath, so dir 'ultisnips' is loaded from
  " ~/.config/nvim/ultisnips hence why using property:
  " g:UltiSnipsSnippetDirectories not g:UltiSnipsSnippetsDir
  " NOTE: having multiple snippet directories causes coc to prompt for source
  " selection, so override to only custom source
  let g:UltiSnipsSnippetDirectories=["ultisnips"]

  packadd! ultisnips

  nnoremap <leader>ue :UltiSnipsEdit<CR>
  nnoremap <leader>ur :call UltiSnips#RefreshSnippets()<CR>
endif
" }}} ultisnips
" {{{ lightline
" Update status bar to include search case insensitivity state
" call ToggleSmartsearch#toggle()

let g:lightline = {
      \ 'colorscheme': 'tender',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'currentfunction', 'cocstatus', 'readonly', 'filename', 'modified' ] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'search_case_sensativity_state', 'fileformat', 'fileencoding', 'filetype' ] ]
      \ },
      \ 'component_function': {
	    \   'cocstatus': 'coc#status',
      \   'currentfunction': 'CocCurrentFunction',
      \   'search_case_sensativity_state': 'togglesmartsearch#statepretty'
      \ },
      \ }

let g:toggle_smartsearch_state = 1
"
" Use auocmd to force lightline update.
augroup cocgroup
  autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()
augroup END

function! CocCurrentFunction()
    return get(b:, 'coc_current_function', '')
endfunction
" }}} lightline
" {{{ coc - conquer of code
if executable('node')
  set shell=/bin/sh

  " coc extensions to laod
  " coc-java : auto downloads eclipse java lsp
  " coc-solargraph : ruby lsp
  " TODO only load java and solargraph if correct filetype
  let g:coc_global_extensions = [
    \ 'coc-java',
    \ 'coc-json',
    \ 'coc-ultisnips',
    \ 'coc-solargraph'
    \]

  " The following are required to match the ultisnips mappings
  let g:coc_snippet_next = '<TAB>'
  let g:coc_snippet_prev = '<S-TAB>'

  packadd! coc

  " disable auto preview on complete
  " set completeopt-=preview

  " show signcolumn all the time, as jumps around when linting
  set signcolumn=yes

  " Better display for messages
  set cmdheight=2

  " You will have bad experience for diagnostic messages when it's default 4000.
  set updatetime=300

  " don't give |ins-completion-menu| messages.
  set shortmess+=c

  " always show signcolumns
  set signcolumn=yes

  " Use <c-space> to trigger completion.
  inoremap <silent><expr> <c-space> coc#refresh()

  " Use `[g` and `]g` to navigate diagnostics
  nmap <silent> [g <Plug>(coc-diagnostic-prev)
  nmap <silent> ]g <Plug>(coc-diagnostic-next)

  " Remap keys for gotos
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  " conflicts with  built in 'gi'
  " nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)

  " Use K to show documentation in preview window
  nnoremap <silent> K :call <SID>show_documentation()<CR>

  function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
    else
      call CocAction('doHover')
    endif
  endfunction

  " Highlight symbol under cursor on CursorHold
  autocmd CursorHold * silent call CocActionAsync('highlight')

  " Remap for rename current word
  nmap <leader>rn <Plug>(coc-rename)

  " Remap for format selected region
  " xmap <leader>f  <Plug>(coc-format-selected)
  " nmap <leader>f  <Plug>(coc-format-selected)

  augroup mygroup
    autocmd!
    " Setup formatexpr specified filetype(s).
    autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
    " Update signature help on jump placeholder
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  augroup end

  " Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
  xmap <leader>a  <Plug>(coc-codeaction-selected)
  nmap <leader>a  <Plug>(coc-codeaction-selected)

  " Remap for do codeAction of current line
  nmap <leader>ac  <Plug>(coc-codeaction)
  " Fix autofix problem of current line
  nmap <leader>qf  <Plug>(coc-fix-current)

  " Create mappings for function text object, requires document symbols feature of languageserver.
  xmap if <Plug>(coc-funcobj-i)
  xmap af <Plug>(coc-funcobj-a)
  omap if <Plug>(coc-funcobj-i)
  omap af <Plug>(coc-funcobj-a)

  " Use <C-d> for select selections ranges, needs server support, like: coc-tsserver, coc-python
  " nmap <silent> <C-d> <Plug>(coc-range-select)
  " xmap <silent> <C-d> <Plug>(coc-range-select)

  " Use `:Format` to format current buffer
  command! -nargs=0 Format :call CocAction('format')

  " Use `:Fold` to fold current buffer
  command! -nargs=? Fold :call     CocAction('fold', <f-args>)

  " use `:OR` for organize import of current buffer
  command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

  " Add status line support, for integration with other plugin, checkout `:h coc-status`
  set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

  " Using CocList
  " Show all diagnostics
  nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
  " Manage extensions
  nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
  " Show commands
  nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
  " Find symbol of current document
  nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
  " Search workspace symbols
  nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
  " Do default action for next item.
  nnoremap <silent> <space>j  :<C-u>CocNext<CR>
  " Do default action for previous item.
  nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
  " Resume latest coc list
  nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
endif
" }}} coc - conquer of code
" {{{ vim-gutentags
let g:gutentags_ctags_tagfile = '.git/tags'
" }}} vim-gutentags
" {{{ vim-highlight
nnoremap <leader>h1 :HighlightLine hlYellow<cr>
vnoremap <leader>h1 :'<,'>HighlightLine hlYellow<cr>
nnoremap <leader>h2 :HighlightLine hlDarkBlue<cr>
vnoremap <leader>h2 :'<,'>HighlightLine hlDarkBlue<cr>
nnoremap <leader>rh :RemoveHighlighting<cr>
vnoremap <leader>rh :'<,'>RemoveHighlighting<cr>
" }}} vim-highlight
" {{{ vim-tmux-navigator
" I don't want the defualt TmuxNavigatePrevious mapping
let g:tmux_navigator_no_mappings = 1
nnoremap <silent> <c-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <c-j> :TmuxNavigateDown<cr>
nnoremap <silent> <c-k> :TmuxNavigateUp<cr>
nnoremap <silent> <c-l> :TmuxNavigateRight<cr>

" Disable tmux navigator when zooming the Vim pane
let g:tmux_navigator_disable_when_zoomed = 1

" Saves the hassel of saving the buffer when switching to, saves all buffers
" a terminal pane
let g:tmux_navigator_save_on_switch = 2
" }}} vim-tmux-navigator
" {{{ Terminal / Plugin
nnoremap <leader>rr :<C-u>TerminalReplFile<cr>
nnoremap <leader>rt :<C-u>TerminalReplFileToggle<cr>
" }}} Terminal / Plugin
" }}} Plugin Settings
" {{{ Custom Mappings
" {{{ Splits
" THIS IS DISABLED IN FAVOUR OF TmuxNavigateXXX
" bindings, see plugin config above
" See here for good tips: https://thoughtbot.com/blog/vim-splits-move-faster-and-more-naturally
" Easier split navigation
" nnoremap <C-J> <C-W><C-J>
" nnoremap <C-K> <C-W><C-K>
" nnoremap <C-L> <C-W><C-L>
" nnoremap <C-H> <C-W><C-H>

" See: https://vim.fandom.com/wiki/Resize_splits_more_quickly
" Increase/Decrease vertical windows
nnoremap <leader>+ :vertical resize +10<CR>
nnoremap <leader>- :vertical resize -10<CR>

" }}} Splits
" {{{ TABs
" easier tab navigation
nnoremap [T  :tabfirst<CR>    " moves to first tab
nnoremap ]t  :tabnext<CR>     " moves to next tab
nnoremap [t  :tabprev<CR>     " moves to previous tab
nnoremap ]T  :tablast<CR>     " moves to last tab
nnoremap <leader>1 1gt<CR>    " moves to tab 1
nnoremap <leader>2 2gt<CR>    " moves to tab 2
nnoremap <leader>3 3gt<CR>    " moves to tab 3
nnoremap <leader>4 4gt<CR>    " moves to tab 4
nnoremap <leader>5 5gt<CR>    " moves to tab 5
nnoremap <leader>6 6gt<CR>    " moves to tab 6
nnoremap <leader>7 7gt<CR>    " moves to tab 7
nnoremap <leader>8 8gt<CR>    " moves to tab 8
nnoremap <leader>9 9gt<CR>    " moves to tab 9

" opens new tab
nnoremap tn  :tabnew<CR>

" closes tab
nnoremap tc  :tabclose<CR>
" }}} TABs
" {{{ Quicklist
" TODO set these up so that they close what ever locaton / quickfix window is
" open... if more than one just close first one found
nnoremap <leader>cl :copen<CR>   " Open Quicklist
nnoremap <leader>cc :cclose<CR>  " Close quicklist
"
" To quickly go through the Quicklist
nnoremap ]c :cn<CR>
nnoremap [c :cp<CR>
" }}} Quicklist End
" {{{ Buffer Navigation
" Easier navigation with file buffer
" list open buffers
nnoremap <leader>ls :ls<CR>:b<Space>
nnoremap [b :bprevious<CR>
nnoremap ]b :bnext<CR>
nnoremap <leader>bd :bdelete<CR>
" }}} Buffer Navigation
" {{{ Window related
nnoremap <leader>wc :close<CR>
" }}} Window related
" {{{ Yank and paste to system clipboard
" These apply for all modes
noremap <Leader>Y "*y
noremap <Leader>P "*p
noremap <Leader>y "+y
noremap <Leader>p "+p
" }}} Yank and paste to system clipboard
" {{{ Formatting helpers
" Replace first pair of double quotes on line with single
" return back to cursor location
nnoremap cdq mp0f"r';.`p
nnoremap csq mp0f'r";.`p

" Toggle paste mode
set pastetoggle=<F2>
" }}} Formatting helpers
" Wrap visual selection in double quotes
vnoremap <leader>s" :<esc>`<i"<esc>`>la"<esc>

" Wrap visual selection in single quotes
vnoremap <leader>s' :<esc>`<i'<esc>`>la'<esc>

" exit insert mode and save buffer
inoremap jj <ESC>:w<cr>

" insert a line above or below, and exit back to normal
" TODO if this is run from a comment line then it adds a comment prefix which
" I don't want
nnoremap <leader>o o<ESC>k
nnoremap <leader>O O<ESC>j

" Reselect previous selection (gv) in visual mode
" after indenting left or right
vnoremap < <gv
vnoremap > >gv

" Select last pasted text
nnoremap gp `[v`]

" Format current paragraph
nnoremap <leader>= Vap=

" {{{ Navigation
" Disable arrow keys
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
"inoremap <up> <nop>
"inoremap <down> <nop>
"inoremap <left> <nop>
"inoremap <right> <nop>

" In insert more move using readline line start/end
inoremap <c-e> <esc>A
inoremap <c-a> <esc>I

" Basic bracket closing
"inoremap " ""<left>
"inoremap ' ''<left>
"inoremap ` ``<left>
"inoremap ``` ```<CR>```<ESC>O
"inoremap < <><left>
"inoremap ( ()<left>
"inoremap [ []<left>
"inoremap { {}<left>
"inoremap {<CR> {<CR>}<ESC>O
"inoremap {;<CR> {<CR>};<ESC>O

" }}} Navigation
" {{{ vimrc related
" Open vimrc in vertical split
nnoremap <silent><leader>ev :vsplit $MYVIMRC<cr>
" Source shared vim config
nnoremap <silent><leader>sv :w<cr>:source $MYVIMRC<cr>:echo "vimrc sourced mother licker"<cr>
" }}} vimrc related
" }}} Custom Mappings
" {{{ Abbreviations
" Source my abbreviations
:iabbrev teh the
:iabbrev adn and
" }}} Abbreviations
" Functions
" {{{ Search Related

" Opens a new tab with the quickfix list
" and selects the first item
function! TabbedQuicklistViewer() abort
  " echom "In function"
  if empty(getqflist())
    echo "No results to display"
  else
    " open a new tab
    tabnew
    " open quickfix list
    copen
    " register macro to select next qf item
    " and run it so it's in the `@:` register
    " which is a hack to pre-populate the
    " read-only register `@:`
    let @l=':call TabbedQuicklistNextItem()'
    normal @l
    " select first item in top pane
    cfirst
  endif
endfunction

" Opens a new tab with quickfix list open, selecting first item
command! TabbedQuicklistViewer call TabbedQuicklistViewer()

" This calls `cn`, then checks if the current position
" is within a folded line, if so it expands the fold
function! TabbedQuicklistNextItem()
  cnext
  " if fold closed `-1` then expand
  if foldclosed(line('.')) > -1
    foldopen
    " wincmd t
  endif

  " if buffer has changed then select top-left split
  let thisbuf = bufnr("%")
  let lastwin = winnr("#")
  let lastbuf = winbufnr(lastwin)
  if thisbuf != lastbuf
    wincmd t
  endif
endfunction

" Autocommand to open quickfix list if populated...
augroup quickfix
    autocmd!
    autocmd QuickFixCmdPost [^l]* :call TabbedQuicklistViewer()
    autocmd QuickFixCmdPost l*    lwindow
augroup END
" }}} Search Related
" {{{ Scratch Buffer Related
" Scratch buffer name
if !exists('s:scratch_buffer_name')
 let s:scratch_buffer_name = 'scratch'
endif

" Scratch paste from register name
if !exists('s:scratch_paste_register')
 let s:scratch_paste_register = '*'
endif

" Opens a scratch buffer, if one exists already open that
command! Scratch call Scratch()
" Puts the contents on the scratch_paste_register into the scratch buffer
command! PasteToScratch call PasteToScratch()

" Opens a scratch buffer window
" If no buffer exists then create window and buffer
" If buffer and window exist then move to it
" If buffer exist but not in window then open in split
function! Scratch()
  " if scratch buffer exists
  if bufnr(s:scratch_buffer_name) > 0
    " buffer exists check to see if window exists
    let scratch_window_name = bufwinnr(s:scratch_buffer_name)
    if scratch_window_name > 0
      execute scratch_window_name . 'wincmd w'
    else
      " open in split
      execute 'vsplit' s:scratch_buffer_name
    endif
  else
    " otherwise open new split as setup
    split
    noswapfile hide enew
    setlocal buftype=nofile
    setlocal bufhidden=hide
    execute 'file' s:scratch_buffer_name
  endif
endfunction

" If a scratch buffer exists then paste from the +
" register
function! PasteToScratch()
  " capture current and scratch buffers
  let current_buffer = bufnr('%')
  let scratch_buffer = bufnr(s:scratch_buffer_name)
  if scratch_buffer > 0
    " move to scratch buffer if not already in it
    " as moving to same window sporks
    if current_buffer != scratch_buffer
      call Scratch()
    endif
    " at end of file add new line and then reg contents
    call append(line('$'), '')
    call append(line('$'), getreg(s:scratch_paste_register))
    if current_buffer != scratch_buffer
      execute current_buffer . 'wincmd w'
    endif
  else
    echom "No scratch file found"
  endif
endfunction
" }}} Scratch Buffer Related
" {{{ Prototyping helpers
"
" This function copies visual selection
" pastes it below and comments out original
" leaving cursor in first line on copied selection
" It has a dependency on vim-commentary plugin
xnoremap <leader>pro :<c-u>call Prototype()<CR>

function! Prototype() range
  try
    let a_save = @a
    normal! gv"ay`>pgv
    execute "normal \<Plug>Commentary"
    normal! `>j
    return @a
  finally
    let @a = a_save
  endtry
endfunction
" }}} Prototyping helpers
" {{{ list related

" Runs a search {pat} and returns results in a location list
function! LocationListFromPattern(pat)
    let buffer=bufnr("") "current buffer number
    let b:lines=[]
    execute ":%g/" . a:pat . "/let b:lines+=[{'bufnr':" . 'buffer' . ", 'lnum':" . "line('.')" . ", 'text': escape(getline('.'),'\"')}]"
    call setloclist(0, [], ' ', {'items': b:lines})
    lopen
endfunction
" }}} list related
" {{{ Random Functions

" Show highlight group under cursor
" https://stackoverflow.com/questions/9464844/how-to-get-group-name-of-highlighting-under-cursor-in-vim
function! SynGroup()
    let l:s = synID(line('.'), col('.'), 1)
    echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfun
" }}} Random Functions

" TODO this is not complete
" A tool to take a selection and make it 'pretty',
" this is very much in the testing stages
function! MakePretty(type) abort
  " Store current selection setting and @@ register
  let l:sel_save = &selection
  let &selection = "inclusive"
  let l:reg_save = @@

  if a:type ==? "v" " invoked from visual mode
    silent exe "normal! `<" . a:type . "`>y"
  elseif a:type ==? "V" " invoked from visual line mode
    silent exe "normal! '[V']y"
  else
    " invoved from normal mode so select current word
    " silent exe "normal! `[v`]y"
    silent exe "normal! viwy"
  endif

  echom "selection: " . @@

  " Restore current selection setting and @@ register
 let &selection = l:sel_save
  let @@ = l:reg_save
endfunction
nnoremap <silent> <leader>mp :<C-u>call MakePretty(visualmode())<CR>
vnoremap <silent> <leader>mp :<C-u>call MakePretty(visualmode())<Cr>

" Opens the ftplugin for the given filetype
function! OpenFTPluginFile() abort
  let l:filetype_file = expand($VIMCONFIG . '/ftplugin/' . &filetype . '.vim')
  execute 'edit ' . l:filetype_file
endfunction
" Wrap OpenFTPluginFile function in a command which opens the ftplugin file
" for given file
command! -nargs=0 OpenFTPluginFile call OpenFTPluginFile()

