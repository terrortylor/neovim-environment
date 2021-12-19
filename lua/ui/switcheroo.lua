-- inspired by switch.vim, but that is way above what I ever really need
-- most the time I want to just toggle between true and false TBH
local M = {}

-- define things to toggle here, a better list will be created
-- in setup that allows toggleing back and forth
M.swapperoos = {
  ["true"] = "false",
  ["=="] = "!=",
}

-- set with helper func in setup
M.swap_map = {}

function M.do_switcheroo()
  local cword = vim.fn.expand('<cword>')
  local replace = M.swap_map[cword]
  if replace == nil then
    print("No alternative found for: " .. cword)
    return
  end
  vim.cmd("normal! ciw" .. replace)
end

function M.create_switch_map(map)
  local switches = {}

  for k,v in pairs(map) do
    switches[k]= v
    switches[v]= k
  end

  return switches
end

function M.setup()
 vim.api.nvim_set_keymap("n", "<leader>tw", "<CMD>lua require('ui.switcheroo').do_switcheroo()<CR>", {noremap = true})
end

return M
