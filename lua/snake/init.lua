-- Lifted from: https://simplegametutorials.github.io/snake/
-- For the sake of it :P
require'snake.lib.cell'
require'snake.lib.snake'
local input = require'snake.lib.input'
local sprites = require'snake.lib.sprites'
local api = vim.api
local M = {}

-- Stores sprite  buffers used to paint snake / food
sprites.create_sprite("body", "X")
sprites.create_sprite("food", "$")

local timer
local speed = 100
local snake = Snake:new(nil, sprites.get_sprite("body"))
local food = Cell:new(nil, 0, 0, sprites.get_sprite("food"))
-- Stores window with / height
local canvas = {}

function M:get_next_pos()
  local x = snake.segments[1].x
  local y = snake.segments[1].y

  local direction = input.get_direction()

  if direction == 'right' then
    x = x + 1
    if x > canvas.width then
      x = 1
    end
  elseif direction == 'left' then
    x = x - 1
    if x < 1 then
      x = canvas.width
    end
  elseif direction == 'down' then
    y = y + 1
    if y > canvas.height then
      y = 1
    end
  elseif direction == 'up' then
    y = y - 1
    if y < 1 then
      y = canvas.height
    end
  end

  return x, y
end

function M.update()
  local next_x_pos, next_y_pos = M.get_next_pos()

  if snake:collision(next_x_pos, next_y_pos) then
    M.stop()
    -- TODO print error so clearer... or new window
    api.nvim_command("echo 'Bad luck'")
  else
    local has_eaten = false
    if next_x_pos == food.x
      and next_y_pos == food.y then
      has_eaten = true
    end

    snake:move(next_x_pos, next_y_pos, has_eaten)
    if has_eaten then
      M.new_food()
    end
    snake:draw()
    food:draw()
  end
end

function M.new_food()
  food:close_window()

  local possible_positions = {}

  for food_x = 1, canvas.width do
    for food_y = 1, canvas.height do
      local possible = true

      for segmentIndex, segment in ipairs(snake.segments) do
        if food_x == segment.x and food_y == segment.y then
          possible = false
        end
      end

      if possible then
        table.insert(possible_positions, {x = food_x, y = food_y})
      end
    end
  end

  pos = possible_positions[math.random(#possible_positions)]
  new_food = Cell:new(nil, pos.x, pos.y, sprites.get_sprite("food"))
  food = new_food
end

function M.start()
  -- setup/capture canvas size
  local current_win_id = api.nvim_tabpage_get_win(0)
  canvas.width = api.nvim_win_get_width(current_win_id)
  canvas.height = api.nvim_win_get_height(current_win_id)

  -- draw some food
  M.new_food()

  -- setup keymaps
  input.setup_mappings()

  -- begin main game loop
  timer = vim.loop.new_timer()
  timer:start(0, speed, vim.schedule_wrap(function()
    M.update()
  end))
end

function M.stop()
  timer:close()
  -- Cleanup
  for _,v in ipairs(snake_segments) do
    M.close_window(v.w_id)
  end
  M.close_window(food.w_id)
  -- TODO restore keymappings
  -- TODO Unload / wipe all sprite buffers
end

return M
