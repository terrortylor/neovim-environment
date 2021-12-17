local M = {}

-- TODO rather than list each switch, do single switch and build a new list of possible combinations
M.swapperoos = {
  ["true"] = "false",
  ["false"] = "true",
  ["=="] = "!=",
  ["!="] = "=="
}

function M.do_switcheroo()
  local cword = vim.fn.expand('<cword>')
  local replace = M.swapperoos[cword]
  if replace == nil then
    print("No alternatice found for: " .. cword)
    return
  end
  vim.cmd("normal! ciw" .. replace)
end

function M.setup()
 vim.api.nvim_set_keymap("n", "<leader>sw", "<CMD>lua require('ui.switcheroo').do_switcheroo()<CR>", {noremap = true})
end

return M
