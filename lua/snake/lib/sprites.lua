local api = vim.api
local M = {}

local sprites = {}

function M.get_sprite(name)
  local sprite = sprites[name]

  if sprite then
    return sprite
  end

  return 0
end

function M.create_sprite(name, text)
  local sprite = M.get_sprite(name)
  if sprite and sprite > 0 then
    return sprite
  end

  local buf_id = api.nvim_create_buf(false, true)
  api.nvim_buf_set_option(buf_id, 'filetype', 'snakegame')
  -- TODO last col should be 1 not -1
  api.nvim_buf_set_lines(buf_id, 0, -1, true, {text})
  api.nvim_buf_add_highlight(buf_id, -1, "snake"..name, 0, 0, -1)

  sprites[name] = buf_id

  return buf_id
end

return M
