" Add markdown snippets to note type
UltiSnipsAddFiletypes wiki.markdown

nnoremap gf :lua require("wiki").follow_link()<CR>

nnoremap [l :lua require("ui.buffer.nav").find_next("?", "[[")<CR>
nnoremap ]l :lua require("ui.buffer.nav").find_next("/", "[[")<CR>
