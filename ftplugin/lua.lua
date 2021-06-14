local opts = {noremap = true}
local function keymap(...) vim.api.nvim_buf_set_keymap(0, ...) end

-- Run all tests
-- TODO this isn't working?!?
keymap("n", "<leader>gtf", "<Plug>PlenaryTestFile", opts)
