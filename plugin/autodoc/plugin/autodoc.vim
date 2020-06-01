" TODO some charecters like: ^R are note printing out... see vim.vim
" TODO update README with new custom plugins etc
" Generates a markdown table that displays the active mappings in nvim's
" init.vim file. As mappings are often grouped it maintains the order that
" they are declared.
" File:       vim_doc_generator.vim
" Maintainer: Alex Tylor

if exists('g:loaded_autodoc_plugin')
  finish
endif
let g:loaded_autodoc_plugin = 1


if !exists('g:autodoc_show_missing')
  let g:autodoc_show_missing = v:false
endif

" Where my config lives, look at actual repository location
if !exists('g:autodoc_config_path')
  let g:autodoc_config_path = fnamemodify(expand("$MYVIMRC"), ":p:h")
endif

" Controls weather or not to show the rhs of mappings/action of commands
if !exists('g:autodoc_table_show_action')
  let g:autodoc_table_show_action = v:true
endif

" Searches for 'documentation' tags and populates them accordingly, based on
" mapping/command definitions and comments
command! -nargs=0 GenerateVimMappingDocumentationTable call GenerateDocumentation()

" Generates 'documentation' tags for files in a number of locations
command! -nargs=0 GenerateVimMappingDocumentationTags call GenerateDocumentationTags()

" Generates missing 'documentation' tags for files in a number of locations
command! -nargs=0 GenerateVimMappingMissingDocumentationTags call GenerateMissingDocumentationTags()

