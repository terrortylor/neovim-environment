-- TODO add docs
local log = require('util.log')
local escape = require('util.string').escape

local api = vim.api

local M = {}

M.config = {
  -- Linters preffer comment and line to hae a space in between
  left_marker_padding = true
}

local function get_comment_wrapper()
  local cs = api.nvim_buf_get_option(0, 'commentstring')

  -- make sure comment string is understood
  if cs:find('%%s') then
   local left = cs:match('^(.*)%%s')
   local right = cs:match('^.*%%s(.*)')

   -- left comment markers should have padding as linterers preffer
   -- TODO config option
   if  M.config.left_marker_padding then
     if not left:match("%s$") then
       left = left .. " "
     end
   end

   return left, right
  else
    log.debug('Commentstring not understood: ' .. cs)
  end
end

local function comment_line(l, indent, left, right)
  local line = l
  local comment_pad = indent

  -- most linters want padding to be formatted correctly
  -- so remove comment padding from line
  if comment_pad then
    line = l:gsub("^" .. comment_pad, "")
  else
    comment_pad = ""
  end

  if right ~= '' then
    line = line .. right
  end
  line = comment_pad .. left .. line
  return line
end

local function uncomment_line(l, left, right)
  local line = l
  if right ~= '' then
    local esc_right = escape(right)
    line = line:gsub(esc_right .. '$', '')
  end
  local esc_left = escape(left)
  line = line:gsub(esc_left, '', 1)

  return line
end

function M.operator()
  local mode = vim.api.nvim_call_function("visualmode", {})
  local line1, line2
  if not mode then
    line1 = vim.api.nvim_win_get_cursor(0)[1]
    line2 = line1
  elseif mode == "V" then
    line1 = vim.api.nvim_buf_get_mark(0, "<")[1]
    line2 = vim.api.nvim_buf_get_mark(0, ">")[1]
  else
    line1 = vim.api.nvim_buf_get_mark(0, "[")[1]
    line2 = vim.api.nvim_buf_get_mark(0, "]")[1]
  end
    M.comment_toggle(line1, line2)
end

function M.comment_toggle(line_start, line_end)
  local left, right = get_comment_wrapper()
  if not left or not right then
    return
  end

  local lines = api.nvim_buf_get_lines(0, line_start - 1, line_end, false)
  if not lines then
    return
  end

  -- check if any lines commented,
  -- capture indent
  local esc_left = escape(left)
  local commented_lines_counter = 0
  local indent
  for _,v in pairs(lines) do
    if v:find('^%s*' .. esc_left) then
      commented_lines_counter = commented_lines_counter + 1
    end
    -- TODO what if already commented line has smallest indent?
    -- TODO no tests for this indent block

    local line_indent = v:match("^%s+")
    if line_indent and (not indent or string.len(line_indent) < string.len(indent)) then
      indent = line_indent
    end
  end

  local comment = true
  if commented_lines_counter == #lines then
    comment = false
  end

  for i,v in pairs(lines) do
    local line
    if comment then
      line = comment_line(v, indent, left, right)
    else
      line = uncomment_line(v, left, right)
    end
    lines[i] = line
  end

  api.nvim_buf_set_lines(0, line_start - 1, line_end, false, lines)

  -- The lua call seems to clear the visual selection so reset it
  -- 2147483647 is vimL built in
  api.nvim_call_function("setpos", {"'<", {0, line_start, 1, 0}})
  api.nvim_call_function("setpos", {"'>", {0, line_end, 2147483647, 0}})
end

-- TODO add tests
-- TODO move to directory?
-- TODO make repeatable
function M.setup()
  api.nvim_command("command! -range CommentToggle lua require('ui.buffer.comment').comment_toggle(<line1>, <line2>)")
end

if _TEST then
  M._get_comment_wrapper = get_comment_wrapper
  M._comment_line = comment_line
  M._uncomment_line = uncomment_line
end

return M
