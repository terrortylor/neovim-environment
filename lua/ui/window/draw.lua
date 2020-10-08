local api = vim.api

local M = {}

local toggled_bufs = {}

-- TODO this doesn't take into account tabs atm
local function is_buf_open(buf)
  for _,w in pairs(api.nvim_list_wins()) do
    if buf == api.nvim_win_get_buf(w) then
      return w
    end
  end
  return nil
end

local function get_split_command(position, size)
  size = size or ""
  -- TODO use either props.size or half screen size, which ever is smaller
  local command = ""
  if position == 'top' then
    command = 'topleft'
  elseif position == 'bottom' then
    command = 'botright'
  elseif position == 'left' then
    command = 'vertical topleft'
  else
    command = 'vertical botright'
  end
  return string.format("%s %ssplit", command, size)
end

local function open_draw(buf, position, size)
  api.nvim_command(get_split_command(position, size))
  api.nvim_command('buffer ' .. buf)
  return api.nvim_get_current_win()
end

local function close_draw(win)
  api.nvim_set_current_win(win)
  api.nvim_command('close')
end

function M.toggle(buf, position, size)
  -- capture current location
  local props = toggled_bufs[buf]
  if props then
    if props.win then
      close_draw(win)
      props.win = nil
    else
      props.win = open_draw(buf, position, size)
    end
  else
    props = {
      position = position,
      size = size
    }
    toggled_bufs[buf] = props
    props.win = open_draw(buf, position, size)
  end
  --restore current location
end

if _TEST then
  M._is_buf_open = is_buf_open
  M._get_split_command = get_split_command
  M._open_draw = open_draw
  M._close_draw = close_draw
end

return M
