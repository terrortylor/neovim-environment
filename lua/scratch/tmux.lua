local tmux_list_panes = function()
  local result = vim.fn.system("tmux list-panes")
  local lines = {}
  for s in result:gmatch("[^\r\n]+") do
    table.insert(lines, s)
  end
  return lines
end


--- Gets the number of tmux panes open in current window
local get_number_tmux_panes = function()
  return #tmux_list_panes()
end

--- Gets the number of the active tmux panes open in current window
local get_active_tmux_panes = function()
  local lines = tmux_list_panes()
  for i,v in pairs(lines) do
    if v:find("%(active%)$") then
      return i
    end
  end
  return 0
end

print("number of panes", get_number_tmux_panes())
print("current page", get_active_tmux_panes())
