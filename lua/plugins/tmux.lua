return {
  {
    -- tmux/vim magic!
    "christoomey/vim-tmux-navigator",
    config = function()
      -- vim.g.tmux_navigator_no_mappings = 1
      vim.g.tmux_navigator_disable_when_zoomed = 1
      vim.g.tmux_navigator_save_on_switch = 2
    end,
  },
}
