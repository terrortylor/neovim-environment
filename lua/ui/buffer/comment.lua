local log = require('util.log')
local escape = require('util.string').escape

local api = vim.api

local M = {}

local function get_comment_wrapper()
  local cs = api.nvim_buf_get_option(0, 'commentstring')

  -- make sure comment string is understood
  if cs:find('%%s') then
   local left = cs:match('^(.*)%%s')
   local right = cs:match('^.*%%s(.*)')
   return left, right
  else
    log.debug('Commentstring not understood: ' .. cs)
  end
end

local function comment_line_decorator(l, clean, left, right)
  local line = l
  if clean then
    local esc_left = escape(left)
    line = line:gsub('^' .. esc_left, '')
    if right ~= '' then
      local esc_right = escape(right)
      line = line:gsub(esc_right .. '$', '')
    end
  end
  if right ~= '' then
    line = line .. right
  end
  line = left .. line
  return line
end

local function uncomment_line_decorator(l, left, right)
  local line = l
  if right ~= '' then
    local esc_right = escape(right)
    line = line:gsub(esc_right .. '$', '')
  end
  local esc_left = escape(left)
  line = line:gsub('^' .. esc_left, '')

  return line
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

  local count = 0
  local esc_left = escape(left)
  for _,v in pairs(lines) do
    if v:find('^' .. esc_left) then
      count = count + 1
    end
  end

  local comment = true
  local clean = false
  if count == #lines then
    comment = false
  elseif count > 0 then
    clean = true
  end

  for i,v in pairs(lines) do
    local line = ''
    if comment then
      line = comment_line_decorator(v, clean, left, right)
    else
      line = uncomment_line_decorator(v, left, right)
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
function M.setup()
  api.nvim_command("command! -range CommentToggle lua require('ui.buffer.comment').comment_toggle(<line1>, <line2>)")
end

if _TEST then
  M._get_comment_wrapper = get_comment_wrapper
  M._comment_line_decorator = comment_line_decorator
  M._uncomment_line_decorator = uncomment_line_decorator
end

return M
