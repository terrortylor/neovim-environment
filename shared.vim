" This file uses folding to better organise:
" :help fold-commands
" {{{ VIM Settings
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

" enable spell checking
set spell spelllang=en_gb
" }}} General Settings
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

" Fine tune to ignore file types
set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png,*.ico
set wildignore+=*.pdf,*.psd
set wildignore+=node_modules/*,bower_components/*

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

" Format the status line
set laststatus=2
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
set ignorecase
set smartcase

" Highlight search
set incsearch
set showmatch
set hlsearch

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
" }}} NERDTree
" {{{ netrw
" Configure netrw plugin to show file ls details
" See: https://shapeshed.com/vim-netrw/
let g:netrw_liststyle = 1
" }}} netrw
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
" Also easier tab navigation
nnoremap th  :tabfirst<CR>    " moves to first tab
nnoremap tk  :tabnext<CR>     " moves to next tab
nnoremap tj  :tabprev<CR>     " moves to previous tab
nnoremap tl  :tablast<CR>     " moves to last tab

" move to X tab
nnoremap tn  :tabnext<Space>

" moves current tab to X position
nnoremap tm  :tabm<Space>

" closes tab
nnoremap td  :tabclose<CR>
" }}} TABs

" Easier navigation with file buffer
" list open buffers
nnoremap <leader>l :ls<CR>

" Search and replace word under cursor
nnoremap <leader>r :%s/<c-r><c-w>/

" NOTE: leader is default '\'
" Toggle spell checking
nnoremap <leader>s :set spell!<CR>

" Wrap visual selection in double quotes
vnoremap <leader>" :<esc>`<i"<esc>`>la"<esc>

" Wrap visual selection in single quotes
vnoremap <leader>' :<esc>`<i'<esc>`>la'<esc>

" Open new tab in explorer
nnoremap <leader>E :Texplore<CR>

" Map 'jj' in insert more to escape back to normal
inoremap jj <ESC>
" Save buffer
nnoremap ff :w<CR>

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
nnoremap <leader>ev :vsplit $SHARED_CONF<cr>
" Source shared vim config
nnoremap <leader>sv :source $SHARED_CONF<cr>

" }}} Custom Mappings
" {{{ Abbreviations
" Source my abbreviations
:iabbrev teh the
:iabbrev adn and
" }}} Abbreviations
