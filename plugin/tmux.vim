" TODO if argument passed then use that as command, no panel number behaviour change
command! -nargs=0 TmuxSendCommandToPane call luaeval('require("tmux.send_command").send_command_to_pane()', expand('<args>'))
command! -nargs=0 TmuxSendOneOffCommandToPane call luaeval('require("tmux.send_command").send_one_off_command_to_pane()', expand('<args>'))

command! -nargs=0 TmuxClearUserCommand call luaeval('require("tmux.send_command").clear_user_command()', expand('<args>'))
command! -nargs=0 TmuxClearPaneNumber call luaeval('require("tmux.send_command").clear_pane_number()', expand('<args>'))


" TODO check if better ran to call this... i.e just :lua blabla
nnoremap <Plug>(TmuxPaneScrollUp) :lua require('tmux.send_command').scroll(true)<CR>
nnoremap <Plug>(TmuxPaneScrollDown) :lua require('tmux.send_command').scroll(false)<CR>
nmap <silent> <C-PAGEUP> <Plug>(TmuxPaneScrollUp)
nmap <silent> <C-PAGEDOWN> <Plug>(TmuxPaneScrollDown)
