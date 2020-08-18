" TODO if argument passed then use that as command, no panel number behaviour change
command! -nargs=0 TmuxSendCommandToPane call luaeval('require("tmux.send_command").send_command_to_pane()', expand('<args>'))

command! -nargs=0 TmuxClearUserCommand call luaeval('require("tmux.send_command").clear_user_command()', expand('<args>'))
command! -nargs=0 TmuxClearPaneNumber call luaeval('require("tmux.send_command").clear_pane_number()', expand('<args>'))
