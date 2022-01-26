local M = {}

function M.setup()
  local refactor = require("refactoring")
  refactor.setup({
    -- prompt for return type
    prompt_func_return_type = {
      go = true,
    },
    -- prompt for function parameters
    prompt_func_param_type = {
      go = true,
    },
  })

  local function keymap(...) vim.api.nvim_set_keymap(...) end
  local opts = {noremap = true, silent = true, expr = false}
  keymap("v", "<Leader>re", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>]], opts)
  keymap("v", "<Leader>rf", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>]], opts)
  keymap("v", "<Leader>rv", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>]], opts)
  keymap("v", "<Leader>ri", [[ <Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]], opts)

  -- load refactoring Telescope extension
  require("telescope").load_extension("refactoring")

  -- remap to open the Telescope refactoring menu in visual mode
  keymap(
  "v",
  "<leader>rr",
  "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>",
  { noremap = true }
  )

  keymap(
  "n",
  "<leader>rp",
  ":lua require('refactoring').debug.printf({below = false})<CR>",
  { noremap = true }
  )

  -- Print var: this remap should be made in visual mode
  keymap("v", "<leader>rv", ":lua require('refactoring').debug.print_var({})<CR>", { noremap = true })

  -- Cleanup function: this remap should be made in normal mode
  keymap("n", "<leader>rc", ":lua require('refactoring').debug.cleanup({})<CR>", { noremap = true })
end

return M
