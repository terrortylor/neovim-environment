local M = {}

function M.setup()
  local custom_toggle_term_strategy = function(cmd)
    require('ui.window.toggle_term').open("vim-test", "bash", false, cmd)
  end

  local custom_tmux_strategy = function(cmd)
    require('tmux.commands').seed_instance_command("tmux-test-runner", cmd)
    require('tmux.commands').send_command_to_pane("tmux-test-runner")
  end

  vim.g["test#javascript#jest#executable"] = "yarn test"
  vim.g["test#custom_strategies"] = {
    customtmuxstrategy = custom_tmux_strategy,
    customtoggletermstrategy = custom_toggle_term_strategy
  }
  vim.g["test#strategy"] = 'customtoggletermstrategy'

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
