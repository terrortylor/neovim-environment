" TODO ignorecase is off.. thought this should be on as default on nvim...
" also check that autowrite is working as expected
" maybe from my crappy plugin?

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
    autocmd ColorScheme * highlight Folded ctermfg=56 ctermbg=215 cterm=NONE
  augroup END

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
    autocmd BufRead,BufNewFile init.vim setl
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
  " TODO move this out to function for consistency
  augroup return_to_last_edit_in_buffer
    autocmd!
    autocmd BufReadPost *
          \ if line("'\"") > 0 && line("'\"") <= line("$") |
          \     execute 'normal! g`"zvzz' |
          \ endif
  augroup END

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

  " Show file options above the command line, in a more bash list way
  " matching on full/longest
  set wildmode=list,longest
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

  " See: https://vim.fandom.com/wiki/Display_line_numbers
  " show current line number and relative line numbers
  set number
  set relativenumber!

  " Highlight current cursor line
  set cursorline

  " Toggle on and off as entering/leaving windows
  " TODO fix issue with toggling nerdtree
  augroup cursor_line_group
    autocmd!
    autocmd WinEnter * setlocal cursorline
    autocmd WinLeave * setlocal nocursorline
  augroup END

  " }}} Visual Settings
  " {{{ Buffer auto load / save

  " autosave buffers when switching between then
  set autowrite

  " Auto remove trailing whitespace on :w
  augroup remove_trailing_whitespace
    autocmd!
    autocmd BufWritePre * %s/\s\+$//e
  augroup END

  " }}} Buffer auto load / save
  " {{{ Searching within a buffer behaviour

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
  nnoremap <leader>rw :%s/<c-r><c-w>//<left>
  " Search and replace visual selection.
  " When in visual mode the selection delimiters are added automatically
  vnoremap <leader>rw :s/<c-r>"//<left>

  " Custom Grep (tabbed view) for selection within current directory, path can
  " be added
  vnoremap <leader>gg y:Grep <c-r>"
  " Custom Grep for selection within current directory with standard quickfix
  " window, path can be added
  vnoremap <leader>sg y:SimpleGrep <c-r>"
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
  " }}} quickfix
  " {{{ vim-sneak

  " There is some remapping of 's' to '<space>s' see after/plugin/vim-sneak.vim

  " }}} vim-sneak
  " {{{ NERDTree

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

    augroup auto_reload_snippets_after_write
      autocmd!
      autocmd BufWritePost *.snippets :call UltiSnips#RefreshSnippets()
    augroup END
  endif

  " }}} ultisnips
  " {{{ coc - conquer of code

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

    " Remap for format selected region
    " xmap <leader>f  <Plug>(coc-format-selected)
    " nmap <leader>f  <Plug>(coc-format-selected)

    " TODO rename this augroup
    augroup mygroup
      autocmd!
      " Setup formatexpr specified filetype(s).
      autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
      " Update signature help on jump placeholder
      autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
    augroup end

    " Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
    " xmap <leader>a  <Plug>(coc-codeaction-selected)
    " nmap <leader>a  <Plug>(coc-codeaction-selected)

    " Remap for do codeAction of current line
    " nmap <leader>ac  <Plug>(coc-codeaction)
    " Fix autofix problem of current line
    " nmap <leader>qf  <Plug>(coc-fix-current)

    " Create mappings for function text object, requires document symbols feature of languageserver.
    " NOTE: these may be overridden in ftplugin files, i.e. vim overrides af
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

    " TODO now started to use space as leader review these
    " Using CocList
    " Show all diagnostics
    nnoremap <silent> <leader>ld  :<C-u>CocList diagnostics<cr>
    " Manage extensions
    nnoremap <silent> <leader>le  :<C-u>CocList extensions<cr>
    " Show commands
    nnoremap <silent> <leader>lc  :<C-u>CocList commands<cr>
    " Find symbol of current document
    nnoremap <silent> <leader>lo  :<C-u>CocList outline<cr>
    " Search workspace symbols
    nnoremap <silent> <leader>ls  :<C-u>CocList -I symbols<cr>
    " Do default action for next item.
    nnoremap <silent> <leader>j  :<C-u>CocNext<CR>

    " Do default action for previous item.
    nnoremap <silent> <leader>k  :<C-u>CocPrev<CR>

    " Resume latest coc list
    nnoremap <silent> <leader>p  :<C-u>CocListResume<CR>
  endif

  " }}} coc - conquer of code
  " {{{ vim-go

  " See ftplugin/go.vim for mappings

  " }}} vim-go
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

  " Saves the hassel of saving the buffer when switching to another tmux pane, saves all buffers
  " a terminal pane
  let g:tmux_navigator_save_on_switch = 2

  " }}} vim-tmux-navigator
  " {{{ Terminal / Plugin

  " TODO maybe remap to leader gr
  " can toggle be used only!?
  nnoremap <leader>rr :<C-u>TerminalReplFile<cr>
  " TODO find better chord
  nnoremap <leader>rt :<C-u>TerminalReplFileToggle<cr>

  " }}} Terminal / Plugin
  " {{{ vim-color-xcode

  augroup set_green_comments
    autocmd!
    autocmd ColorScheme * let g:xcodedarkhc_green_comments = 1
  augroup END

  " }}} vim-color-xcode
  " {{{ rainbow_parentheses.vim

  augroup enable_rainbow_on_vim_enter
    autocmd!
    autocmd VimEnter * RainbowParentheses
  augroup END
  let g:rainbow#pairs = [['(', ')'], ['[', ']'], ['{', '}']]

  " }}} rainbow_parentheses.vim
" }}} Plugin Settings

" {{{ Custom Mappings
  " {{{ Splits

  " Load of tmux navigator isn't loaded
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
  nnoremap <leader>tc :tabclose<CR> " closes current tab
  nnoremap <leader>tn :tabnew<CR>   " opens a tab

  " }}} TABs
  " {{{ Quicklist

  " TODO set these up so that they close what ever locaton / quickfix window is
  " open... if more than one just close first one found
  nnoremap <leader>cl :copen<CR>   " Open Quicklist
  nnoremap <leader>cc :cclose<CR>  " Close quicklist
  "
  " To quickly go through the Quicklist
  nnoremap ]c :cnext<CR>
  nnoremap [c :cprevious<CR>

  " }}} Quicklist End
  " {{{ Buffer Navigation

  " Easier navigation with file buffer
  " list open buffers
  " nnoremap <leader><space> :ls<CR>:b<Space>

  nnoremap [b :bprevious<CR>
  nnoremap ]b :bnext<CR>
  nnoremap <leader>bd :bdelete<CR>

  " easier switching to alternate/last buffer
  nnoremap <leader>a <c-^>

  " Make <c-e> & <c-y> a bit more useable
  nnoremap <c-y> 5<c-y>
  nnoremap <c-e> 5<c-e>

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
  " }}} Spelling
  " {{{ Write and Source
  nnoremap <leader>ws :w <bar> source %<CR>
  " }}} Write and Source
  " {{{ Marks
  " 'm' is my default quick mark, so this is quick jump mark 'm' to save my
  " pinky :P
  nnoremap <leader>mm `m
  " }}} Marks

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
  " {{{ list related

  " TODO move to quickfix plugin
  " Runs a search {pat} and returns results in a location list
  function! LocationListFromPattern(pat)
      let buffer=bufnr("") "current buffer number
      let b:lines=[]
      execute ":%g/" . a:pat . "/let b:lines+=[{'bufnr':" . 'buffer' . ", 'lnum':" . "line('.')" . ", 'text': escape(getline('.'),'\"')}]"
      call setloclist(0, [], ' ', {'items': b:lines})
      lopen
  endfunction

  command! -nargs=1 LSimpleGrep call LocationListFromPattern('<args>')

  " }}} list related
  " {{{ Random Functions

  " Opens the ftplugin for the given filetype
  function! OpenFTPluginFile() abort
    let l:filetype_file = expand($VIMCONFIG . '/ftplugin/' . &filetype . '.vim')
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
  " {{{ Toggle Functions
  " TODO This should be moved into a single plugin
  let s:hidden_all = 0
  function! ToggleHiddenAll()
    if s:hidden_all  == 0
      let s:hidden_all = 1
      set noshowmode
      set noruler
      set laststatus=0
      set noshowcmd
      set nonumber
      set norelativenumber
    else
      let s:hidden_all = 0
      set showmode
      set ruler
      set laststatus=2
      set showcmd
      set number
      set relativenumber
    endif
  endfunction
  " }}} Toggle Functions

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
