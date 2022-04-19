local M = {}

local function select_strategy()
  local set_selection = function(item, _)
    vim.g["test#strategy"] = item
  end

  vim.ui.select({ "TmuxPane", "PopupTerm" }, { prompt = "Select Test strategy:" }, set_selection)
end

function M.setup()
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

  require("util.config").create_mappings({
    n = {
      ["gtf"] = "<cmd>TestFile<CR>",
      ["gts"] = "<cmd>TestSuite<CR>",
      ["gtl"] = "<cmd>TestLast<CR>",
      ["gtt"] = "<cmd>TestLast<CR>", -- this is just faster
      ["gtn"] = "<cmd>TestNearest<CR>",
    },
  })

  vim.api.nvim_create_user_command("TestStrategySelect", select_strategy, { force = true })
end

-- helpers for plenary
local lua_last_file = ""
function M.lua_test_file()
  lua_last_file = vim.fn.expand("%:p")
  vim.cmd("wall")
  require("plenary.test_harness").test_directory(lua_last_file)
end

function M.lua_test_last()
  vim.cmd("wall")
  require("plenary.test_harness").test_directory(lua_last_file)
end

return M
