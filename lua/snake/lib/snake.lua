require("snake.lib.cell")

-- Meta class
Snake = { segments = {} }

-- Derived class method new

--TODO o not required here as not doing any inhertience
function Snake:new(o, buf_id)
	o = o or {}
	o.segments = {
		-- Cell:new(nil, 15, 1, buf_id),
		-- Cell:new(nil, 14, 1, buf_id),
		-- Cell:new(nil, 13, 1, buf_id),
		-- Cell:new(nil, 12, 1, buf_id),
		-- Cell:new(nil, 11, 1, buf_id),
		-- Cell:new(nil, 10, 1, buf_id),
		-- Cell:new(nil, 9, 1, buf_id),
		-- Cell:new(nil, 8, 1, buf_id),
		-- Cell:new(nil, 7, 1, buf_id),
		-- Cell:new(nil, 6, 1, buf_id),
		-- Cell:new(nil, 5, 1, buf_id),
		-- Cell:new(nil, 4, 1, buf_id),
		Cell:new(nil, 3, 1, buf_id),
		Cell:new(nil, 2, 1, buf_id),
		Cell:new(nil, 1, 1, buf_id),
	}
	o.sprite = buf_id
	setmetatable(o, self)
	self.__index = self
	return o
end

-- Derived class method printArea
function Snake:draw()
	for _, v in ipairs(self.segments) do
		v:draw()
	end
end

function Snake:move(x, y, has_eaten)
	local new_snake_segment = Cell:new(nil, x, y, self.sprite)
	table.insert(self.segments, 1, new_snake_segment)
	if not has_eaten then
		local removed = table.remove(self.segments)
		removed:close_window()
	end
end

function Snake:collision(x, y)
	-- look for collision
	for i, v in ipairs(self.segments) do
		if i ~= #self.segments and x == v.x and y == v.y then
			return true
		end
	end

	return false
end

function Snake:cleanup()
	for _, v in ipairs(self.segments) do
		v:close_window()
	end
end
