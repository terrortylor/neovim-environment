local M = {}

local getCapture = function()
  local line_nr = vim.api.nvim_win_get_cursor(0)[1]
  local line = vim.api.nvim_get_current_line()
  local cur_pos, _ = line:find("%p") -- first punctuation charecter
  local captures = vim.treesitter.get_captures_at_pos(0, line_nr - 1, cur_pos)
  if vim.tbl_isempty(captures) then
    return ""
  end
  print("capture", captures[1].capture)
  return captures[1].capture
end

local getPrefix = function(capture)
  if capture:find("^neorg.headings.") then
    return "*"
  elseif capture:find("^neorg.lists.ordered.*") then
    return "~"
  elseif capture:find("^neorg.lists.unordered.*") then
    return "-"
  end
  return ""
end

local indedent = function(indent)
  local prefix = getPrefix(getCapture())
  if prefix == "" then
    return
  end
  local line = vim.api.nvim_get_current_line()
  if indent then
    line = line:gsub("^(%s*)%"..prefix, "%1"..prefix..prefix)
  else
    line = line:gsub("^(%s*)%"..prefix, "%1")
  end
  vim.api.nvim_set_current_line(line)
end

function M.indent()
  indedent(true)
end

function M.dedent()
  indedent(false)
end

return M
