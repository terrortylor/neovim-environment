" the nvim ruby ftplugin overrides gf: /usr/share/nvim/runtime/ftplugin/ruby.vim
" so override it here
nnoremap gf :wincmd f<CR>

" Adds jump to recipe locally
setlocal path+=.,**1/recipes

" Adds core cookbook to path
if isdirectory($HOME . '/workspace/review')
  setlocal path+=$HOME/workspace/review/**1/cookbooks/**1/recipes
  " This path is required for the includeexpr functions bellow
  setlocal path+=$HOME/workspace/review/**1
endif

" Covers edge case:
" include_recipe 'firewall' => firewall/recipes/default.rb
function! LoadChefRecipe(fname)
  if a:fname !~ "::"
    return "cookbooks/" . a:fname . "/recipes/default.rb"
  endif
endfunction

set includeexpr=LoadChefRecipe(v:fname)

" Allow '-' to be classed as a word charecter
set iskeyword+=_
