lua require 'config'

" Override fold highlighting
augroup vimrc_highlight_overrides
  autocmd!
  " TODO choose better colours
  autocmd ColorScheme * highlight Folded guifg=56 guibg=215
augroup END

" Source shared vim config
augroup auto_load_vimrc_on_write
  autocmd!
  autocmd BufWritePost init.vim :source %
        \ | echo "vimrc sourced mother licker"
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

" This is for plasticboy/vim-markdown
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

let g:ctrlp_extensions = ['marks']

if has("python3")
  packadd! ultisnips

  nnoremap <leader>ue :UltiSnipsEdit<CR>:set filetype=snippets<CR>

  " TODO this is apparently supported OOTB
  augroup auto_reload_snippets_after_write
    autocmd!
    autocmd BufWritePost *.snippets :call UltiSnips#RefreshSnippets()
  augroup END
endif


" TODO have a think about this plugin, overlaps with TMUX one
" " Run buffer in REPL
" nnoremap <leader>rr :<C-u>TerminalReplFile<cr>
" " Toggle REPL Terminal
" nnoremap <leader>tr :<C-u>TerminalReplFileToggle<cr>

" Open lazy git in throw away popup window
" TODO problem about this is it uses <space> to stage/unstage a file which
" is leader so either pause, or hit <CR> but that goes into stage view so
" have to hit <ESC>
" SEE HERE: https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md
" Mapping file needs to be persisted to ansible
command! -nargs=0 Lazygit call helper#float#SingleUseTerminal('lazygit')
nnoremap <leader>lg :<CR>
" }}} git

colorscheme tender
" helptags ALL

" Opens first non empty list, location list is local to window
nnoremap <leader>cl :call quickfix#window#OpenList()<CR>
" Close all quicklist windows
nnoremap <leader>cc :call quickfix#window#CloseAll()<CR>
