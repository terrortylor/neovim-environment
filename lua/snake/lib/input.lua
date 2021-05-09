local api = vim.api
local M = {}

local direction = {"right"}

local control_mappings = {
  -- TODO esc not currently handled
  ["<ESC>"] = "lua require('snake.lib.input').key_pressed('close')<CR>",
  ["k"] = ":lua require('snake.lib.input').key_pressed('up')<CR>",
  ["j"] = ":lua require('snake.lib.input').key_pressed('down')<CR>",
  ["h"] = ":lua require('snake.lib.input').key_pressed('left')<CR>",
  ["l"] = ":lua require('snake.lib.input').key_pressed('right')<CR>",
}

-- TODO should this jus tbe global?
function M.get_direction()
	-- TODO better way of handling this queue... want to prevent going back on self but is this the right way?
        if #direction > 1 then
            table.remove(direction, 1)
        end
  return direction[1]
end

function M.setup_mappings()
  for k,v in pairs(control_mappings) do
    api.nvim_set_keymap("n", k, v, {noremap = true, silent = true})
  end
end

function M.teardown_mappins()
  for k,_ in pairs(control_mappings) do
    vim.api.nvim_del_keymap("n", k)
  end
end

function M.key_pressed(key)
  if key == 'right'
    and direction[#direction] ~= 'right'
    and direction[#direction] ~= 'left' then
        table.insert(direction, 'right')

    elseif key == 'left'
    and direction[#direction] ~= 'left'
    and direction[#direction] ~= 'right' then
        table.insert(direction, 'left')

    elseif key == 'up'
    and direction[#direction] ~= 'up'
    and direction[#direction] ~= 'down' then
        table.insert(direction, 'up')

    elseif key == 'down'
    and direction[#direction] ~= 'down'
    and direction[#direction] ~= 'up' then
        table.insert(direction, 'down')
    end
end

return M
