local M = {}

function M.run_macro(recording, register)
  register = register or "a"
  -- backup register to put macro in
  local old_reg = vim.fn.getreg(register)
  local old_reg_type = vim.fn.getregtype(register)

  vim.fn.setreg(register, recording, old_reg_type)
  -- call with keeppatterns so not to change search history
  vim.cmd("keeppatterns normal @" .. register)

  vim.fn.setreg(register, old_reg, old_reg_type)
end

return M
