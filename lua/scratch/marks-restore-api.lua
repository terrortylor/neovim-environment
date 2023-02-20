local cmd_output = vim.api.nvim_exec("marks", true)
print("each line")
local marks = {}
for line in cmd_output:gmatch("([^\n]*)\n?") do
  local tokens = {}
  for token in string.gmatch(line, "[^%s]+") do
    table.insert(tokens, token)
  end
  table.insert(marks, tokens)
end
table.remove(marks, 1)
for _, v in pairs(marks) do
  vim.pretty_print(v)
end
