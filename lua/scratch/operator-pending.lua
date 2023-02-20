local counter = 0

function _G.__dot_repeat(motion) -- 4.
  local cur_pos = vim.api.nvim_win_get_position(0)
  vim.pretty_print(cur_pos)
  if motion == nil then
    -- vim.o.operatorfunc = "v:lua.__dot_repeat" -- 3.
    vim.api.nvim_set_option("operatorfunc", "v:lua.__dot_repeat")
    return "g@" -- 2.
  end

  print("counter:", counter, "motion:", motion)
  counter = counter + 1
end

vim.keymap.set("n", "gt", _G.__dot_repeat, { expr = true }) -- 1.
