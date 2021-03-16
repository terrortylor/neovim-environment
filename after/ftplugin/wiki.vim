" Add markdown snippets to note type
UltiSnipsAddFiletypes wiki.markdown

nnoremap <buffer> gf :lua require("wiki").follow_link()<CR>

nnoremap <buffer> [l :lua require("ui.buffer.nav").find_next("?", "[[")<CR>
nnoremap <buffer> ]l :lua require("ui.buffer.nav").find_next("/", "[[")<CR>
