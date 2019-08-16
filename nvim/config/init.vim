filetype plugin indent on
" This file uses folding to better organise:
" :help fold-commands
" {{{ VIM Settings
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
" }}} Swap, Backup and Undo File Location
" {{{ Setup folding rules
" Global to indent, and not close them by default
set foldmethod=indent
set nofoldenable

" vim file folding overrides
au FileType vim setl foldmethod=marker foldenable

" }}} VIM Settings
" {{{ General Settings
" don't bother about trying to support older versions
set nocompatible

" }}} General Settings
" {{{ Spelling
" Toggle spell checking
nnoremap <leader>s :set spell!<CR>
" disable spell checking on start but set language
set nospell spelllang=en_gb
" }}} Spelling
" {{{ Indentation
" Configure indentation to spaces of width 2
" https://stackoverflow.com/questions/1878974/redefine-tab-as-4-spaces
set tabstop=2 softtabstop=0 expandtab shiftwidth=2 smarttab

" Autoindent from previous line
" Note that this seems to be on in neovim
set autoindent
" }}} Indentation
" {{{ Window scrolling behaviour
" Scroll before reaching the start/end of file
set scrolloff=5
" }}} Window scrolling behaviour
" {{{ Searching for files

" Show file options above the command line
set wildmenu
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

" Always showstatus bar
set laststatus=2
" Format the status line
set statusline=%f       "Path of the file
set statusline+=%=      "left/right separator
set statusline+=[%{strlen(&fenc)?&fenc:'none'}, "file encoding
set statusline+=%{&ff}] "file format
set statusline+=%h      "help file flag
set statusline+=%m      "modified flag
set statusline+=%r      "read only flag
set statusline+=%y      "filetype
set statusline+=%3c,     "cursor column
set statusline+=%4l/%L   "cursor line/total lines
set statusline+=\ %P    "percent through file

" Highlight current cursor line
set cursorline
" Toggle on and off as entering/leaving windows
au WinEnter * setlocal cursorline
au WinLeave * setlocal nocursorline

" }}} Visual Settings
" {{{ Buffer auto load / save
" autosave buffers when switching between then
set autowrite

" Auto load changes from the filesytem
set autoread

" Auto remove trailing whitespace on :w
autocmd BufWritePre * %s/\s\+$//e
" }}} Buffer auto load / save
" {{{ Searching within a buffer behaviour

" Set searching to only use case when an uppercase is used
" set ignorecase
" set smartcase

" Highlight search
set incsearch
set showmatch
set hlsearch

" Set global flag on for search are replace
" :help gdefault
set gdefault

" Search and replace word under cursor
nnoremap <leader>r :%s/<c-r><c-w>/

" turns of highlighting
nnoremap <leader><space> :noh<CR>
" }}} Searching within a buffer behaviour
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
" }}} VIM Settings
" {{{ Plugin Settings
" {{{ NERDTree
nnoremap <C-\> :call NerdToggleFind()<CR>

" Open NERDTree at current file location, close if open
function! NerdToggleFind()
  if exists("g:NERDTree")
    if g:NERDTree.IsOpen()
      NERDTreeToggle
    else
      NERDTreeFind
    endif
  endif
endfunction

" Autoclose vim if only NERDTree open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Jump to open buffer if open:
let g:ctrlp_switch_buffer = 'Et'
" }}} NERDTree
" {{{ netrw
" Configure netrw plugin to show file ls details
" See: https://shapeshed.com/vim-netrw/
let g:netrw_liststyle = 1
"
" Hide noisey banner
let g:netrw_banner = 0

" Open new tab in explorer
nnoremap <leader>E :Texplore<CR>
" }}} netrw
" {{{ ultisnips
" Ultisnips is used as it's fiarly light weight and is jsut the engine.
let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsListSnippets  = '<c-tab>'
let g:UltiSnipsJumpForwardTrigger = '<c-j>'
let g:UltiSnipsJumpBackwardTrigger = '<c-k>'

" This just sets the path of where we edit/create personnal snippets
let g:UltiSnipsSnippetsDir=$HOME . "/.config/nvim/ultisnips"
" But the engine that loads the snippets for runtime
" load from neovim's runtimepath, so dir 'ultisnips' is loaded from
" ~/.config/nvim/ultisnips hence why using property:
" g:UltiSnipsSnippetDirectories not g:UltiSnipsSnippetsDir
let g:UltiSnipsSnippetDirectories=["UltiSnips", "ultisnips"]
" }}} ultisnips
" {{{ lightline
" Update status bar to include search case insensitivity state
" call ToggleSmartsearch#toggle()

let g:lightline = {
      \ 'colorscheme': 'tender',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'filename', 'modified' ] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'search_case_sensativity_state', 'fileformat', 'fileencoding', 'filetype' ] ]
      \ },
      \ 'component_function': {
      \   'search_case_sensativity_state': 'ToggleSmartSearch#StatePretty'
      \ },
      \ }

let g:toggle_smartsearch_state = 1
" }}} lightline
" }}} Plugin Settings
" {{{ Custom Mappings
" {{{ Splits
" See here for good tips: https://thoughtbot.com/blog/vim-splits-move-faster-and-more-naturally
" Easier split navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" See: https://vim.fandom.com/wiki/Resize_splits_more_quickly
" Increase/Decrease vertical windows
nnoremap <leader>+ :vertical resize +10<CR>
nnoremap <leader>- :vertical resize -10<CR>

" }}} Splits
" {{{ TABs
" easier tab navigation
nnoremap th  :tabfirst<CR>    " moves to first tab
nnoremap tk  :tabnext<CR>     " moves to next tab
nnoremap tj  :tabprev<CR>     " moves to previous tab
nnoremap tl  :tablast<CR>     " moves to last tab
nnoremap <leader>1 1gt        " moves to tab 1
nnoremap <leader>2 2gt        " moves to tab 2
nnoremap <leader>3 3gt        " moves to tab 3
nnoremap <leader>4 4gt        " moves to tab 4
nnoremap <leader>5 5gt        " moves to tab 5
nnoremap <leader>6 6gt        " moves to tab 6
nnoremap <leader>7 7gt        " moves to tab 7
nnoremap <leader>8 8gt        " moves to tab 8
nnoremap <leader>9 9gt        " moves to tab 9

" opens new tab
nnoremap tn  :tabnew<Space>

" closes tab
nnoremap tc  :tabclose<CR>
" }}} TABs
" {{{ Quicklist
nnoremap <leader>cl :copen<CR>   " Open Quicklist
nnoremap <leader>cc :cclose<CR>  " Close quicklist
"
" To quickly go through the Quicklist
nnoremap c] :cn<CR>
nnoremap c[ :cp<CR>
" }}} Quicklist End
" {{{ File Buffers
" Easier navigation with file buffer
" list open buffers
nnoremap <leader>b :ls<CR>:b<Space>
" }}} File Buffers
" Wrap visual selection in double quotes
vnoremap <leader>" :<esc>`<i"<esc>`>la"<esc>

" Wrap visual selection in single quotes
vnoremap <leader>' :<esc>`<i'<esc>`>la'<esc>

" Map 'jj' in insert more to escape back to normal
inoremap jj <ESC>
" Save buffer
nnoremap ff :w<CR>
" exit insert mode and save buffer
inoremap jf <ESC>:w<cr>

" insert a line above or below, and exit back to normal
nnoremap <leader>o o<ESC>k
nnoremap <leader>O O<ESC>j

" Reselect previous selection (gv) in visual mode
" after indenting left or right
vnoremap < <gv
vnoremap > >gv

" Disable arrow keys
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
"inoremap <up> <nop>
"inoremap <down> <nop>
"inoremap <left> <nop>
"inoremap <right> <nop>

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

" Open shared vim in vertical split
" Note this is set in the vimrc and neovim init files
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
" Source shared vim config
nnoremap <leader>sv :source $MYVIMRC<cr>
" }}} Custom Mappings
" {{{ Abbreviations
" Source my abbreviations
:iabbrev teh the
:iabbrev adn and
" }}} Abbreviations
" {{{ Functions
" {{{ ToggleSearchCase
" }}} ToggleSearchCase
" }}} Functions
