local M = {}

function M.setup()
  -- vim.api.nvim_set_var("test#strategy", "neovim")
  -- vim.api.nvim_set_var("test#neovim#term_position", "topleft")

  vim.api.nvim_set_var("test#javascript#jest#executable", "yarn test")

  vim.cmd [[
    function! CustomTmuxStrategy(cmd)
      let Seed = luaeval("require('tmux.commands').seed_instance_command")
      call Seed("tmux-test-runner", a:cmd)
      lua require('tmux.commands').send_command_to_pane("tmux-test-runner")
    endfunction

    let g:test#custom_strategies = {'customtmuxstrategy': function('CustomTmuxStrategy')}
    let g:test#strategy = 'customtmuxstrategy'
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
