local M = {}

function M.refactors()
  -- telescope refactoring helper
  local function refactor(prompt_bufnr)
    local content = require("telescope.actions.state").get_selected_entry(
    prompt_bufnr
    )
    require("telescope.actions").close(prompt_bufnr)
    require("refactoring").refactor(content.value)
  end

  local opts = require("telescope.themes").get_cursor() -- set personal telescope options
  require("telescope.pickers").new(opts, {
    prompt_title = "refactors",
    finder = require("telescope.finders").new_table({
      results = require("refactoring").get_refactors(),
    }),
    sorter = require("telescope.config").values.generic_sorter(opts),
    attach_mappings = function(_, map)
      map("i", "<CR>", refactor)
      map("n", "<CR>", refactor)
      return true
    end
  }):find()
end

function M.setup()
  local refactor = require("refactoring")
  refactor.setup()

  local function keymap(...) vim.api.nvim_set_keymap(...) end
  local opts = {noremap = true, silent = true, expr = false}
  keymap("v", "<Leader>re", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>]], opts)
  keymap("v", "<Leader>rf", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>]], opts)
  keymap("v", "<Leader>rt", [[ <Esc><Cmd>lua require('plugins.refactor').refactors()<CR>]], opts)
end

return M
