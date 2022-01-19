local M = {}

function M.setup()
  vim.api.nvim_set_var("test#javascript#jest#executable", "yarn test")

  vim.cmd [[
    function! CustomTmuxStrategy(cmd)
      let Seed = luaeval("require('tmux.commands').seed_instance_command")
      call Seed("tmux-test-runner", a:cmd)
      lua require('tmux.commands').send_command_to_pane("tmux-test-runner")
    endfunction

    function! CustomToggleTermStrategy(cmd)
    echo a:cmd
      let Open = luaeval("require('ui.window.toggle_term').open")
      call Open("vim-test", "bash", v:false, a:cmd)
    endfunction

    let g:test#custom_strategies = {'customtmuxstrategy': function('CustomTmuxStrategy'),
      \'customtoggletermstrategy': function('CustomToggleTermStrategy')}
    " let g:test#strategy = 'customtmuxstrategy'
    let g:test#strategy = 'customtoggletermstrategy'
  ]]

  require('util.config').create_mappings({
    n = {
      ["gtf"]     = "<cmd>TestFile<CR>",
      ["gts"]     = "<cmd>TestSuite<CR>",
      ["gtl"]     = "<cmd>TestLast<CR>",
      ["gtt"]     = "<cmd>TestLast<CR>", -- this is just faster
      ["gtn"]     = "<cmd>TestNearest<CR>",
    },
  })
end

return M
