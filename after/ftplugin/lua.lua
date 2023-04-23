-- TODO change to vim.keymap.set? search for other occourances
local function keymap(...)
  vim.api.nvim_buf_set_keymap(0, ...)
end

-- helpers for plenary
local lua_last_file = ""

-- keymap("n", "<leader>gtf", function()
--   lua_last_file = vim.fn.expand("%:p")
--   vim.cmd("silent! wall")
--   require("plenary.test_harness").test_directory(lua_last_file)
-- end, {})

-- keymap("n", "<leader>gtt", function()
--   if lua_last_file == "" then
--     print("No file tested yet!")
--     return
--   end
--   vim.cmd("silent! wall")
--   require("plenary.test_harness").test_directory(lua_last_file)
-- end, {})
