augroup chefftgroup
  " Handle all rb files
  autocmd BufNewFile,BufRead */cookbooks/*/\(attributes\|libraries\|recipes\|resources\|spec\|test\)/*.rb set filetype=ruby.chef
  " Setup templates erb to use chef
  autocmd BufNewFile,BufRead */cookbooks/*/templates/*/*.erb set filetype=eruby.chef
  " also this one off
  autocmd BufNewFile,BufRead */cookbooks/*/metadata.rb set filetype=ruby.chef
augroup END
