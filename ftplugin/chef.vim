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

lua << EOF
function OpenRecipeSpec()
  local path = vim.api.nvim_call_function("expand", {"%:p"})
  if path:match("/cookbooks/(.-)/recipes/") then
    -- Open spec file
    if not path:match("_spec.rb$") then
      path = path:gsub("/recipes/", "/spec/unit/recipes/")
      path = path:gsub(".rb", "_spec.rb")
      vim.api.nvim_command("e " .. path)
    else
      -- open recipe
      path = path:gsub("/spec/unit/recipes/", "/recipes/")
      path = path:gsub("_spec.rb", ".rb")
      vim.api.nvim_command("e " .. path)
    end
  else
    print("Doesn't look like a chef recipe file, not gonna do anything... okay")
  end
end
EOF
" Toggle between file and test file
nnoremap <leader>ga :<C-u>lua OpenRecipeSpec()<CR>
