" Always show the tab line
set showtabline=2

" Configure indentation to spaces of width 2
" https://stackoverflow.com/questions/1878974/redefine-tab-as-4-spaces
set tabstop=4 softtabstop=0 expandtab shiftwidth=2 smarttab

" Autoindent from previous line
" Note that this seems to be on in neovim
set autoindent

" Scroll before reaching the start/end of file
set scrolloff=5

" Show `▸▸` for tabs: 	, `·` for tailing whitespace:
set list listchars=tab:▸▸,trail:·
" Auto remove trailing whitespace on :w
autocmd BufWritePre * %s/\s\+$//e

" Show file options above the command line
set wildmenu
" Fine tune to ignore file types
set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png,*.ico
set wildignore+=*.pdf,*.psd
set wildignore+=node_modules/*,bower_components/*

" `gf` opens file under cursor in a new vertical split
" See this page on notes on autochdir: https://gist.github.com/csswizardry/9a33342dace4786a9fee35c73fa5deeb
nnoremap gf :vertical wincmd f<CR>

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

" Configure netrw plugin to show file ls details
" See: https://shapeshed.com/vim-netrw/
let g:netrw_liststyle = 1

" See: https://vim.fandom.com/wiki/Resize_splits_more_quickly
" Increase/Decrease vertical windows
nnoremap <leader>+ :vertical resize +10<CR>
nnoremap <leader>- :vertical resize -10<CR>

" See here for good tips: https://thoughtbot.com/blog/vim-splits-move-faster-and-more-naturally
" Easier split navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" autosave buffers when switching between then
set autowrite

" Enable mouse support
":set mouse=a

" Set searching to only use case when an uppercase is used
set ignorecase
set smartcase
" Highlight search
set incsearch
set showmatch
set hlsearch
" turns of highlighting
nnoremap <leader><space> :noh<CR>

" enable syntax highlighting
syntax enable

" enable spell checking
set spell spelllang=en_gb

" Create some shortcuts

" Easier navigation with file buffer
" list open buffers
nnoremap <leader>l :ls<CR>
" Search and replace word under cursor
nnoremap <leader>r :%s/\<<c-r><c-w>\>/
" NOTE: leader is default '\'
" Toggle spell checking
nnoremap <leader>s :set spell!<CR>

" Wrap visual selection in double quotes
vnoremap <leader>" :<esc>`<i"<esc>`>la"<esc>
" Wrap visual selection in single quotes
vnoremap <leader>' :<esc>`<i'<esc>`>la'<esc>

" Open new tab in explorer
nnoremap <leader>E :Texplore<CR>

" NERDTree
" Toggle file explorer
map <C-n> :NERDTreeToggle<CR>
" Autoclose if only nerdtree left open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" Make it prittier
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1

" Map 'jj' in insert more to escape back to normal
inoremap jj <ESC>

" Disable arrow keys
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
"inoremap <up> <nop>
"inoremap <down> <nop>
"inoremap <left> <nop>
"inoremap <right> <nop>

" Open shared vim in vertical split
" Note this is set in the vimrc and neovim init files
nnoremap <leader>ev :vsplit $SHARED_CONF<cr>
" Source shared vim config
nnoremap <leader>sv :source $SHARED_CONF<cr>

" Source my abbreviations
source ~/workspace-personnal/vim-environment/abbreviations.vim

" Plugin specific
" CtrlP
" set a larger than defalt maximum file limit
let g:ctrlp_max_files=200000
let g:ctrlp_max_depth=40
" Ignore some folders and files for CtrlP indexing
let g:ctrlp_custom_ignore = {
\ 'dir':  '\.git$\|\.yardoc\|public$|log\|tmp$|\.vagrant$|\.kitchen$',
\ 'file': '\.so$\|\.dat$|\.DS_Store$'
\}
