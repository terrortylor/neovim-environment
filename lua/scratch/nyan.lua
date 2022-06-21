vim.cmd([[
highlight snakewhite guibg=#ffffff
highlight snakeblack guibg=#000000
highlight snakepink guibg=#fcb2dc
highlight snakelightpurple guibg=#ab51ff
highlight snakedarkpurple guibg=#7437ad
highlight snakesand guibg=#f4c29c
highlight snakered guibg=#fc020a
highlight snakeorange guibg=#ff6a00
highlight snakeyellow guibg=#ffd800
highlight snakegrey guibg=#616160
highlight snakegreen guibg=#00ff21
highlight snakeblue guibg=#0094ff
]])
-- local pink
-- local black
local sprites = require("snake.lib.sprites")
sprites.create_sprite("black", " ")
sprites.create_sprite("pink", " ")
sprites.create_sprite("white", " ")
sprites.create_sprite("red", " ")
sprites.create_sprite("sand", " ")
sprites.create_sprite("orange", " ")
sprites.create_sprite("yellow", " ")
sprites.create_sprite("grey", " ")
sprites.create_sprite("green", " ")
sprites.create_sprite("blue", " ")
sprites.create_sprite("lightpurple", " ")
sprites.create_sprite("darkpurple", " ")

-- pink = Cell:new(nil, 0, 0, sprites.get_sprite("pink"))
-- black = Cell:new(nil, 1, 1, sprites.get_sprite("black"))
-- pink:draw()
-- black:draw()

-- stylua: ignore
local cat = {
  "WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW",
  "WWRRRRRRWWWWWWWBBBBBBBBBBBBBBWWWWWWWW",
  "RRRRRRRRRRRRRRBSSSSSSSSSSSSSSBWWWWWWW",
  "RRRROOOOORRRRBSPPPPQPPQPPPPPPSBWWWWWW",
  "OOOOOOOOOOOOOBSPPQPPPPBBPPPPPSBWBBWWW",
  "OOOYYYYBBBBOOBSPPPPPPBGGPPQPPSBBGGBWW",
  "YYYYYYBGGGBBBBSPPPPPPBGGGBSSSSBGGGBWW",
  "YYYEEEBBGGGGGBSPPPQPPBGGGGBBBBGGGGBWW",
  "EEEEEEEEBBBBGBSPPPPPSBGGGGGGGGGGGGBWW",
  "EEELLLLLLLLBBBSPPPPQBGGGWBGGGGGWBGGBW",
  "LLLLLLLLLLLLLBSPQPPPBGGGBBGGGBGBBGGBW",
  "LLLDDDDDLLLLLBSPPPQPBGPPGGGGGGGGGPPBW",
  "DDDDDDDDDDDDBBSSPQPPBGPPGBGGBGGBGPPBW",
  "DDDWWWWWDDBBBBSSSPPPPBGGGBBBBBBBGGBWW",
  "WWWWWWWWWBGGGBBSSSSSSSBGGGGGGGGGGBWWW",
  "WWWWWWWWWBGGBWBBBBBBBBBBBBBBBBBBBWWWW",
  "WWWWWWWWWBBBWWWBGGBWWWBGGBWBGGBWWWWWW",
  "WWWWWWWWWWWWWWWWBBBWWWWBBBWWBBBBWWWWW",
  "WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW",
}

local grid = { {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {} }

for i, row in ipairs(cat) do
  for j = 1, #row do
    local v = row:sub(j, j)
    if v == "W" then
      grid[i][j] = Cell:new(nil, j - 1, i - 1, sprites.get_sprite("white"))
    elseif v == "R" then
      grid[i][j] = Cell:new(nil, j - 1, i - 1, sprites.get_sprite("red"))
    elseif v == "B" then
      grid[i][j] = Cell:new(nil, j - 1, i - 1, sprites.get_sprite("black"))
    elseif v == "O" then
      grid[i][j] = Cell:new(nil, j - 1, i - 1, sprites.get_sprite("orange"))
    elseif v == "S" then
      grid[i][j] = Cell:new(nil, j - 1, i - 1, sprites.get_sprite("sand"))
    elseif v == "G" then
      grid[i][j] = Cell:new(nil, j - 1, i - 1, sprites.get_sprite("grey"))
    elseif v == "E" then
      grid[i][j] = Cell:new(nil, j - 1, i - 1, sprites.get_sprite("green"))
    elseif v == "L" then
      grid[i][j] = Cell:new(nil, j - 1, i - 1, sprites.get_sprite("blue"))
    elseif v == "P" then
      grid[i][j] = Cell:new(nil, j - 1, i - 1, sprites.get_sprite("pink"))
    elseif v == "Q" then
      grid[i][j] = Cell:new(nil, j - 1, i - 1, sprites.get_sprite("lightpurple"))
    elseif v == "D" then
      grid[i][j] = Cell:new(nil, j - 1, i - 1, sprites.get_sprite("darkpurple"))
    elseif v == "Y" then
      grid[i][j] = Cell:new(nil, j - 1, i - 1, sprites.get_sprite("yellow"))
    end
  end
end

for i, row in ipairs(grid) do
  for j, _ in ipairs(row) do
    grid[i][j]:draw()
  end
end
