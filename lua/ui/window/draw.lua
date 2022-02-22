local api = vim.api

local M = {}

M.toggled_bufs = {}

function M.get_split_command(position, size)
	size = size or ""
	-- TODO use either props.size or half screen size, which ever is smaller
	local command
	if position == "top" then
		command = "topleft"
	elseif position == "bottom" then
		command = "botright"
	elseif position == "left" then
		command = "vertical topleft"
	else
		command = "vertical botright"
	end
	return string.format("%s %ssplit", command, size)
end

function M.open_draw(buf, position, size)
	local props = M.toggled_bufs[buf]
	if not props then
		props = {
			position = position,
			size = size,
		}
		M.toggled_bufs[buf] = props
	end

	if not props.win then
		vim.cmd(M.get_split_command(position, size))
		vim.cmd("buffer " .. buf)
		props.win = api.nvim_get_current_win()
	end
end

function M.close_draw(buf)
	local props = M.toggled_bufs[buf]
	if props and props.win then
		api.nvim_win_close(props.win, false)
		props.win = nil
	end
end

-- TODO works by keeping track but actually needs to check if open/close
function M.toggle(buf, position, size)
	-- capture current location
	local props = M.toggled_bufs[buf]
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

return M
