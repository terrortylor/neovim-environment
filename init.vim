" This file uses folding to better organise:
  " :help fold-commands

" {{{ VIM Settings
  " {{{ leader

  set timeoutlen=1500
  let mapleader = "\<Space>"

  " }}} leader
  " {{{ Theme

  set termguicolors

  " Override fold highlighting
  augroup vimrc_highlight_overrides
    autocmd!
    " TODO choose better colours
    autocmd ColorScheme * highlight Folded guifg=56 guibg=215
  augroup END

  " TODO this colour scheme causes breakage when resourced
  colorscheme xcodedarkhc
  let g:xcodedarkhc_green_comments = 1

  " }}} Theme
  " {{{ Persistent Undofile
  set undofile
  " }}} Persistent Undofile
  " {{{ Setup folding rules

  " Global to indent, and not close them by default
  set foldmethod=indent
  set nofoldenable

  " custom file specific folding overrides
  augroup custom_file_folding
    autocmd!
    autocmd BufRead,BufWinEnter init.vim setlocal
      \ foldmethod=marker
      \ foldenable
      \ fillchars=fold:\  foldtext=MyVimrcFoldText()
  augroup END

  function! MyVimrcFoldText()
      let line = getline(v:foldstart)
      let spaces = substitute(line, '\v^(\s*)"\s+\{.*', '\1', 'g')
      let line_text = substitute(line, '\v^\s*"\s+\{+', '', 'g')
      let foldtext = spaces . '-' . line_text
      return foldtext
  endfunction

  " }}} Setup folding rules
  " {{{ General Settings

  " Allow switching buffers without saving
  set hidden

  " Put curor in same place when re-open a file
  augroup return_to_last_edit_in_buffer
    autocmd!
    autocmd BufReadPost * call s:MoveToLastEdit()
  augroup END

  function! s:MoveToLastEdit() abort
    if line("'\"") > 0 && line("'\"") <= line("$") |
      execute 'normal! g`"zvzz' |
    endif
  endfunction

  " }}} General Settings
  " {{{ Spelling

  " disable spell checking on start but set language
  set nospell
  set spelllang=en_gb

  " }}} Spelling
  " {{{ Indentation

  " Configure indentation to spaces of width 2
  " https://stackoverflow.com/questions/1878974/redefine-tab-as-4-spaces
  set tabstop=2 softtabstop=0 expandtab shiftwidth=2

  " }}} Indentation
  " {{{ Window behaviour

  " Scroll before reaching the start/end of file
  set scrolloff=5

  " Open splits to the right and bellow
  set splitright
  set splitbelow

  " }}} Window  behaviour
  " {{{ Searching for files

  " Show all matches, don't expand to first selection
  set wildmode=full
  set wildignorecase

  set path+=**
  " Fine tune to ignore file types
  set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png,*.ico
  set wildignore+=*.pdf,*.psd
  set wildignore+=node_modules/*,bower_components/*
  set wildignore+=tags,*.session

  " `gf` opens file under cursor in a new vertical split
  " See this page on notes on autochdir: https://gist.github.com/csswizardry/9a33342dace4786a9fee35c73fa5deeb
  nnoremap gf :vertical wincmd f<CR>

  " }}} Searching for file close
  " {{{ Visual Settings

  " Always show the tab line
  set showtabline=2

  " Highlight current cursor line
  set cursorline

  " Toggle on and off as entering/leaving windows
  augroup cursor_line_group
    autocmd!
    autocmd WinEnter * setlocal cursorline
    autocmd WinLeave * setlocal nocursorline
  augroup END

  " }}} Visual Settings
  " {{{ Buffer auto load / save

  " autosave buffers when switching between then
  set autowriteall

  " Auto remove trailing whitespace on :w
  augroup remove_trailing_whitespace
    autocmd!
    autocmd BufWritePre * %s/\s\+$//e
  augroup END

  " }}} Buffer auto load / save
  " {{{ Searching within a buffer behaviour

  " ignorecase when searching
  set ignorecase

  " visually show bracket matches
  set showmatch

  " toggle highlighting
  nnoremap <leader>/ :set hlsearch!<CR>

  " This is neovim specific, makes live s/ changes in buffer
  set inccommand=nosplit

  " Set global flag on for search are replace
  " :help gdefault
  set gdefault
  " }}} Searching within a buffer behaviour
  " {{{ Search and Replace

  " Search and replace word under cursor within buffer
  nnoremap <leader>rw :%s/\C\<<c-r><c-w>\>//<left>
  " Search and replace visual selection.
  " When in visual mode the selection delimiters are added automatically
  vnoremap <leader>rw :s/\C\<<c-r>"\>//<left>

  " }}} Search and Replace
  " {{{ Syntax Highlighting

  " Force syntax highlighting to sync from start of file
  " as syntax highlighting gets messed up when scrolling larger files
  syn sync fromstart
  syn sync minlines=20

  " }}} Syntax Highlighting
  " {{{ Tags

  set tags=./.git/tags;/

  " }}} Tags
  " {{{ Completion
  set completeopt=menuone,preview,noselect,noinsert
  " }}} Completion
" }}} VIM Settings
" {{{ Plugin Settings
  " Cached installed plugins
  call pluginman#CacheInstalledPlugins()

  " {{{ Tabular
  let opts = {'load': 'opt'}
  call pluginman#AddPlugin('https://github.com/godlygeek/tabular', opts)
  " InstallPlugin https://github.com/godlygeek/tabular opts
  packadd tabular
  " }}} Tabluar
  " {{{ vim-markdown
  " tabular needs to be sourced before vim-markdown
  " according to the repository site
  let opts = {'load': 'opt'}
  call pluginman#AddPlugin('https://github.com/plasticboy/vim-markdown', opts)
  packadd vim-markdown

  " Don't require .md extension
  let g:vim_markdown_no_extensions_in_markdown = 1

  " Autosave when following links
  let g:vim_markdown_autowrite = 1

  " }}} vim-markdown
  " {{{ ftplugin markdown
  " This is partly the built in markdown syntax and partly my changes,
  let g:markdown_fenced_languages = ['bash=sh', 'sh', 'ruby']
  " }}} ftplugin markdown
  " {{{ cfilter
  " cfilter is a built in plugin for filtering quickfix and location lists
  " it exposes to new ex command Cfilter and Lfilter
  packadd cfilter
  " }}} cfilter
  " {{{ quickfix
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
  " }}} quickfix
  " {{{ tmux
  nnoremap <leader>nn :lua require('tmux.send_command').send_command_to_pane()<CR>
  " }}} tmux
  " {{{ vim-sneak
  InstallPlugin https://github.com/justinmk/vim-sneak
  " There is some remapping of 's' to '<space>s' see after/plugin/vim-sneak.vim

  " }}} vim-sneak
  " {{{ NERDTree
  InstallPlugin https://github.com/preservim/nerdtree

  " Toggle NERDTree using custom toggle func
  nnoremap <leader>tt :<C-u>call NerdToggleFind()<CR>

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
  augroup nerdtree_group
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
  augroup END
  " Show hidden files
  let NERDTreeShowHidden=1
  " Close after opening a file/bookmark
  " try to force me to use go/gi for preview
  let NERDTreeQuitOnOpen=3

  " }}} NERDTree
  " {{{ CtrlP + Extensions
  InstallPlugin https://github.com/ctrlpvim/ctrlp.vim
  InstallPlugin https://github.com/tacahiroy/ctrlp-funky

  " Disable jumping to window/tab if buffer already open
  let g:ctrlp_switch_buffer = 0

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

  " }}} CtrlP + Extensions
  " {{{ netrw

  " Open new tab in explorer
  " nnoremap <leader>E :Texplore<CR>
  " nnoremap <leader>e :Explore<CR>

  " Open Lexplore with my WIP plugin...
  " nmap <leader>v <Plug>RiceVinegarFind

  " }}} netrw
  " {{{ ultisnips
  let opts = {'load': 'opt'}
  call pluginman#AddPlugin('https://github.com/SirVer/ultisnips', opts)

  if has("python3")
    " Ultisnips is used as it's fiarly light weight and is jsut the engine.
    " Note that if COC is running then these two keybinigs are disabled in
    " favour of <CR>
    let g:UltiSnipsExpandTrigger = '<TAB>'
    " This is doubled up by the fuzzy ultisnips menu
    let g:UltiSnipsListSnippets  = '<c-u>'


    " Jump back and forth between snippet placeholders
    let g:UltiSnipsJumpForwardTrigger = '<TAB>'
    let g:UltiSnipsJumpBackwardTrigger = '<S-TAB>'

    " Want to use <TAB> and <S-TAB> to move through completion menu as well as
    " snippet placeholders. These functions check if the PUMVISIBLE and if so
    " then move up or down accordingly; if not then tried to jump through
    " snipper placeholders, otherwise just do a <TAB>
    function! g:UltiSnipsComplete()
      if pumvisible()
        return "\<C-n>"
      else
        call UltiSnips#JumpForwards()
        if g:ulti_jump_forwards_res == 0
          return "\<TAB>"
        endif
        return ""
      endif
    endfunction

    function! g:UltiSnipsReverse()
      if pumvisible()
        return "\<C-P>"
      else
        call UltiSnips#JumpBackwards()
        if g:ulti_jump_backwards_res == 0
          return "\<S-TAB>"
        endif
        return ""
      endif
    endfunction

    augroup pumvisible_within_snippet
      autocmd!
      autocmd InsertEnter * exec "inoremap <silent> " . g:UltiSnipsJumpForwardTrigger  . " <C-R>=g:UltiSnipsComplete()<cr>"
      autocmd InsertEnter * exec "inoremap <silent> " . g:UltiSnipsJumpBackwardTrigger . " <C-R>=g:UltiSnipsReverse()<cr>"
    augroup END

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

    nnoremap <leader>ue :UltiSnipsEdit<CR>:set filetype=snippets<CR>

    " TODO this is apparently supported OOTB
    augroup auto_reload_snippets_after_write
      autocmd!
      autocmd BufWritePost *.snippets :call UltiSnips#RefreshSnippets()
    augroup END
  endif

  " }}} ultisnips
  " {{{ coc - conquer of code
  " TODO COC introduces a bug where location list is emptied on selection or if closed
  let opts = {'load': 'opt', 'branch': 'release'}
  call pluginman#AddPlugin('https://github.com/neoclide/coc.nvim', opts)

  if executable('node')
    set shell=/bin/sh

    " coc extensions to laod
    " coc-java : auto downloads eclipse java lsp
    " coc-solargraph : ruby lsp
    let g:coc_global_extensions = [
      \ 'coc-java',
      \ 'coc-json',
      \ 'coc-ultisnips',
      \ 'coc-solargraph'
      \]

    " The following are required to match the ultisnips mappings
    let g:coc_snippet_next = '<TAB>'
    let g:coc_snippet_prev = '<S-TAB>'

    packadd! coc.nvim

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

    " Use '<CR>' for completion select
    inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

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

    augroup coc_actions
      autocmd!
      " Setup formatexpr specified filetype(s).
      autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
      " Update signature help on jump placeholder
      autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
    augroup end
  endif

  " }}} coc - conquer of code
  " {{{ vim-go
  InstallPlugin https://github.com/fatih/vim-go

  " See ftplugin/go.vim for mappings

  " }}} vim-go
  " {{{ vim-gutentags
  " TODO sometimes VIM freezes when coming out of background process, think
  " it's gutentags
  InstallPlugin https://github.com/ludovicchabant/vim-gutentags

  let g:gutentags_ctags_tagfile = '.git/tags'

  " }}} vim-gutentags
  " {{{ vim-highlight
  InstallPlugin https://github.com/terrortylor/vim-highlight

  nnoremap <leader>h1 :HighlightLine hlYellow<cr>
  vnoremap <leader>h1 :'<,'>HighlightLine hlYellow<cr>
  nnoremap <leader>h2 :HighlightLine hlDarkBlue<cr>
  vnoremap <leader>h2 :'<,'>HighlightLine hlDarkBlue<cr>
  nnoremap <leader>hr :RemoveHighlighting<cr>
  vnoremap <leader>hr :'<,'>RemoveHighlighting<cr>

  " }}} vim-highlight
  " {{{ vim-tmux-navigator
  InstallPlugin https://github.com/christoomey/vim-tmux-navigator

  " I don't want the defualt TmuxNavigatePrevious mapping
  let g:tmux_navigator_no_mappings = 1

  nnoremap <silent> <c-h> :TmuxNavigateLeft<cr>
  nnoremap <silent> <c-j> :TmuxNavigateDown<cr>
  nnoremap <silent> <c-k> :TmuxNavigateUp<cr>
  nnoremap <silent> <c-l> :TmuxNavigateRight<cr>

  " Disable tmux navigator when zooming the Vim pane
  let g:tmux_navigator_disable_when_zoomed = 1

  " Saves the hassel of saving the buffer when switching to another tmux pane, saves all buffers
  " a terminal pane
  let g:tmux_navigator_save_on_switch = 2

  " }}} vim-tmux-navigator
  " {{{ Terminal / Plugin

  " Run buffer in REPL
  nnoremap <leader>rr :<C-u>TerminalReplFile<cr>
  " Toggle REPL Terminal
  nnoremap <leader>tr :<C-u>TerminalReplFileToggle<cr>

  " }}} Terminal / Plugin
  " {{{ vim-color-xcode
  InstallPlugin https://github.com/arzg/vim-colors-xcode

  augroup set_green_comments
    autocmd!
    autocmd ColorScheme * let g:xcodedarkhc_green_comments = 1
  augroup END

  " }}} vim-color-xcode
  " {{{ rainbow_parentheses.vim
  InstallPlugin https://github.com/junegunn/rainbow_parentheses.vim

  augroup enable_rainbow_on_vim_enter
    autocmd!
    autocmd VimEnter * RainbowParentheses
  augroup END
  let g:rainbow#pairs = [['(', ')'], ['[', ']'], ['{', '}']]

  " }}} rainbow_parentheses.vim
  " {{{ git
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
  InstallPlugin https://github.com/udalov/kotlin-vim
  InstallPlugin https://github.com/machakann/vim-sandwich
  InstallPlugin https://github.com/PProvost/vim-ps1

  " Delete cached installed plugin list
  call pluginman#DeleteCacheInstalledPlugins()
  " TODO need to fix up toggle help file
  " helptags ALL
" }}} Plugin Settings
" {{{ Custom Mappings
  " {{{ Splits

  " See: https://vim.fandom.com/wiki/Resize_splits_more_quickly
  " Increase/Decrease vertical windows
  nnoremap <leader>+ :vertical resize +10<CR>
  nnoremap <leader>- :vertical resize -10<CR>

  " }}} Splits
  " {{{ TABs

  " easier tab navigation
  nnoremap [T  :tabfirst<CR>        " moves to first tab
  nnoremap ]t  :tabnext<CR>         " moves to next tab
  nnoremap [t  :tabprev<CR>         " moves to previous tab
  nnoremap ]T  :tablast<CR>         " moves to last tab
  nnoremap <leader>1 1gt<CR>        " moves to tab 1
  nnoremap <leader>2 2gt<CR>        " moves to tab 2
  nnoremap <leader>3 3gt<CR>        " moves to tab 3
  nnoremap <leader>4 4gt<CR>        " moves to tab 4
  nnoremap <leader>5 5gt<CR>        " moves to tab 5
  nnoremap <leader>6 6gt<CR>        " moves to tab 6
  nnoremap <leader>7 7gt<CR>        " moves to tab 7
  nnoremap <leader>8 8gt<CR>        " moves to tab 8
  nnoremap <leader>9 9gt<CR>        " moves to tab 9
  nnoremap <leader>ct :tabclose<CR> " closes current tab
  nnoremap <leader>nt :tabnew<CR>   " opens a tab

  " }}} TABs
  " {{{ Quicklist

  " Opens first non empty list, location list is local to window
  nnoremap <leader>cl :call quickfix#window#OpenList()<CR>
  " Close all quicklist windows
  nnoremap <leader>cc :call quickfix#window#CloseAll()<CR>
  "
  " To quickly go through the Quicklist
  nnoremap ]c :cnext<CR>
  nnoremap [c :cprevious<CR>

  " }}} Quicklist End
  " {{{ Buffer Navigation

  " Easier navigation with file buffer
  " list open buffers
  " nnoremap <leader><space> :ls<CR>:b<Space>

  " TODO set these up as functions so that if next buffer is quickfix then
  " move to next one
  nnoremap [b :bprevious<CR>
  nnoremap ]b :bnext<CR>
  nnoremap <leader>bd :bdelete<CR>
  " Taken from: https://stackoverflow.com/questions/1444322/how-can-i-close-a-buffer-without-closing-the-window/44950143#44950143
  nnoremap <Leader>bd :call DeleteCurBufferNotCloseWindow()<CR>

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

  " easier switching to alternate/last buffer
  nnoremap <leader>a <c-^>

  " Make <c-e> & <c-y> a bit more useable
  nnoremap <c-y> 5<c-y>
  nnoremap <c-e> 5<c-e>

  " }}} Buffer Navigation
  " {{{ Window related

  " Close window
  nnoremap <leader>cw :close<CR>

  " Toggle line numbers
  nnoremap <leader>tn :set number!<CR>
  " Toggle relative line numbers
  nnoremap <leader>tr :set relativenumber!<CR>


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

  " insert a line above or below, and exit back to normal, this does not
  " continue a comment block
  nnoremap <leader>o :call NewLineNoComment(v:true)<cr>
  nnoremap <leader>O :call NewLineNoComment(v:false)<cr>

  function! NewLineNoComment(below)
    let op = &formatoptions
    set formatoptions-=o
    if a:below == v:true
      execute "normal! o\<ESC>k"
    else
      execute "normal! O\<ESC>j"
    endif
    let &formatoptions = op
  endfunction

  " Reselect previous selection (gv) in visual mode
  " after indenting left or right
  vnoremap < <gv
  vnoremap > >gv
  " Indent line in normal mode
  nnoremap > <s-v>><ESC>
  " Indent line in normal mode
  nnoremap < <s-v><<ESC>

  " Format current paragraph
  nnoremap <leader>= Vap=

  " }}} Formatting helpers
  " {{{ Macro
  nnoremap <leader>q @q
  " }}} Macro Helpers
  " {{{ Navigation

  " In insert more move using readline line start/end
  inoremap <c-e> <esc>A
  inoremap <c-a> <esc>I

  " }}} Navigation
  " {{{ vimrc related
  " Open vimrc in vertical split
  nnoremap <silent><leader>ev :vsplit $MYVIMRC<cr>
  " Source shared vim config
  augroup auto_load_vimrc_on_write
    autocmd!
    autocmd BufWritePost init.vim :source %
          \ | echo "vimrc sourced mother licker"
  augroup END
  " }}} vimrc related
  " {{{ Spelling
  " Auto selects the first spelling suggestion for current word
  nnoremap <leader>zz 1z=

  " Toggle spell checker
  nnoremap <leader>ts :set spell!<CR>

  " Fix last incorrect word in insert mode: https://stackoverflow.com/a/16481737
  inoremap <c-f> <c-g>u<Esc>[s1z=`]a<c-g>u

  " TODO add normal mapping for fix first spelling mistatke on line, retruning to current possition

  " }}} Spelling
  " {{{ Write and Source
  nnoremap <leader>ws :w <bar> source %<CR>
  " }}} Write and Source
  " {{{ Marks
  " 'm' is my default quick mark, so this is quick jump mark 'm' to save my
  " pinky :P
  nnoremap <leader>mm `m
  " }}} Marks
  " {{{ Terminal
  tnoremap <leader><Esc> <C-\><C-n>
  tnoremap <leader>jj <C-\><C-n>
  " }}} Terminal
  " {{{ Searching
  nnoremap <leader>tc :set ignorecase!<cr>
  " }}} Searching

  " exit insert mode and save buffer
  inoremap jj <ESC>:w<cr>

  " Select last pasted text
  nnoremap gp `[v`]
" }}} Custom Mappings
" {{{ Abbreviations

" Source my abbreviations
:iabbrev teh the
:iabbrev adn and

" }}} Abbreviations
" {{{ Functions
  " {{{ Prototyping helpers

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
  " {{{ Random Functions

  " Opens the ftplugin for the given filetype
  function! OpenFTPluginFile() abort
    let l:vim_config_path = fnamemodify(expand("$MYVIMRC"), ":p:h")
    let l:filetype_file = expand(l:vim_config_path . '/ftplugin/' . &filetype . '.vim')
    execute 'edit ' . l:filetype_file
  endfunction
  " Wrap OpenFTPluginFile function in a command which opens the ftplugin file
  " for given file
  command! -nargs=0 OpenFTPluginFile call OpenFTPluginFile()


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
    silent exe "normal! viwy"
  endif

  echom "selection: " . @@

  " Restore current selection setting and @@ register
  let &selection = l:sel_save
  let @@ = l:reg_save
endfunction

nnoremap <silent> <leader>mp :<C-u>call MakePretty(visualmode())<CR>
vnoremap <silent> <leader>mp :<C-u>call MakePretty(visualmode())<Cr>

" }}} Functions
