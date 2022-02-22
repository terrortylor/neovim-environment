local api = vim.api

-- Meta class
Cell = { x = 0, y = 0, win_id = nil, sprite_id = nil }

-- Derived class method new

--TODO o not required here as not doing any inhertience
function Cell:new(o, x, y, sprite_id)
	o = o or {}
	o.x = x or 0
	o.y = y or 0
	o.sprite_id = sprite_id or 0
	setmetatable(o, self)
	self.__index = self
	return o
end

-- Derived class method printArea

function Cell:create_window()
	local opts = {
		style = "minimal",
		relative = "win",
		row = self.y,
		col = self.x,
		width = 1,
		height = 1,
	}
	self.win_id = api.nvim_open_win(self.sprite_id, false, opts)
end

function Cell:close_window()
	if self.win_id then
		if api.nvim_win_is_valid(self.win_id) then
			api.nvim_win_close(self.win_id, true)
		end
	end
end

function Cell:draw()
	self:close_window(self.win_id)
	self:create_window()
end
