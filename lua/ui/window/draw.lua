local api = vim.api

local M = {}

local toggled_bufs = {}

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

function M.open_draw(buf, position, size)
  local props = toggled_bufs[buf]
  if not props then
    props = {
      position = position,
      size = size
    }
    toggled_bufs[buf] = props
  end

  if not props.win then
    api.nvim_command(get_split_command(position, size))
    api.nvim_command('buffer ' .. buf)
    props.win = api.nvim_get_current_win()
  end
end

function M.close_draw(buf)
  local props = toggled_bufs[buf]
  if props and props.win then
    api.nvim_win_close(props.win, false)
    props.win = nil
  end
end

function M.toggle(buf, position, size)
  -- capture current location
  local props = toggled_bufs[buf]
  if props then
    if props.win then
      M.close_draw(buf)
    else
      M.open_draw(buf, position, size)
    end
  else
    M.open_draw(buf, position, size)
  end
  --restore current location
end

if _TEST then
  M._toggled_bufs = toggled_bufs
  M._get_split_command = get_split_command
end

return M
