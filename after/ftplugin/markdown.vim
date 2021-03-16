" Set spelling on as default
setlocal spell spelllang=en_gb

" Note that o is required by todo list plugin stuff
setlocal formatoptions+=o
"setlocal formatoptions=jtqlnor

nnoremap <buffer> [h :lua require("ui.buffer.nav").find_next("?", "^#")<CR>
nnoremap <buffer> ]h :lua require("ui.buffer.nav").find_next("/", "^#")<CR>
