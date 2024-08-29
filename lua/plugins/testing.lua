return {
  {
    "vim-test/vim-test",
    ft = { "javascript", "typescript", "typescriptreact", "go", "lua" },
    config = function()
      local function select_strategy()
        local set_selection = function(item, _)
          vim.g["test#strategy"] = item
        end

        vim.ui.select({ "TmuxPane", "PopupTerm" }, { prompt = "Select Test strategy:" }, set_selection)
      end

      local custom_toggle_term_strategy = function(cmd)
        require("ui.window.toggle_term").open("vim-test", "bash", false, cmd)
      end

      local custom_tmux_strategy = function(cmd)
        require("tmux.commands").seed_instance_command("tmux-test-runner", cmd)
        require("tmux.commands").send_command_to_pane("tmux-test-runner")
      end

      vim.g["test#javascript#jest#executable"] = "yarn test"
      vim.g["test#custom_strategies"] = {
        TmuxPane = custom_tmux_strategy,
        PopupTerm = custom_toggle_term_strategy,
      }
      vim.g["test#strategy"] = "PopupTerm"

      local set = vim.keymap.set
      set("n", "gtf", "<cmd>TestFile<CR>", { desc = "test current file" })
      set("n", "gts", "<cmd>TestSuite<CR>", { desc = "test suit" })
      set("n", "gtl", "<cmd>TestLast<CR>", { desc = "test what ever you tested last" })
      set("n", "gtt", "<cmd>TestLast<CR>", { desc = "test what ever you tested last, quick fire" })
      set("n", "gtn", "<cmd>TestNearest<CR>", { desc = "test nearest test" })

      vim.api.nvim_create_user_command("TestStrategySelect", select_strategy, { force = true })
    end,
  },
}
