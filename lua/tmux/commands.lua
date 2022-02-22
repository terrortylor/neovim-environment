local input = require("tmux.input")
local userInput = require("util.input")
local comstack = require("tmux.instance_command")
local dispatch = require("tmux.dispatch")
local log = require("util.log")

local command_prompt = "Command: "

-- Initialise some local varirables
local instance_pane = {}

local M = {}

-- This is a helper func to be called when starting vim only, for seeding
function M.seed_instance_pane(instance, pane)
	if not instance or not pane then
		return
	end
	instance_pane[instance] = pane
end

function M.seed_instance_command(instance, ...)
	local args = { ... }
	comstack.set_instance_command(instance, table.concat(args, " "))
end

function M.get_instance_pane(instance, clear_first)
	if clear_first == nil then
		clear_first = false
	end

	local pane = instance_pane[instance]

	if clear_first or not pane then
		pane = input.get_pane()
		-- FIXME test if can cast to number, if failed then print error
		--    if type(pane) ~= 'number' then
		--      log.error("Pane entered is not a valid number")
		--      return
		--    end
		instance_pane[instance] = pane
	end

	return pane
end

function M.guarded_send_command(instance, func)
	instance = instance or "1"

	local pane = M.get_instance_pane(instance)
	if not pane then
		log.error("Pane not set")
		return
	end

	local command = func(instance)

	if not command then
		log.error("Command empty")
		return
	end

	dispatch.execute(pane, command)
end

function M.send_command_to_pane(instance)
	M.guarded_send_command(instance, function(func_inst)
		local command = comstack.get_instance_command(func_inst)

		-- if command is nil then run last command (ctrl-p on command line)
		-- so readline mapping dependant
		if not command then
			-- TODO move to M.default_command
			command = "^P"
		end

		return command
	end)
end

function M.set_instance_command(instance)
	M.guarded_send_command(instance, function(func_inst)
		local command = userInput.get_user_input("Enter command: ")

		if not command then
			log.error("Command empty, not setting instance")
			return
		end

		comstack.set_instance_command(func_inst, command)

		return command
	end)
end

function M.send_one_off_command(instance)
	M.guarded_send_command(instance, function()
		local command = userInput.get_user_input(command_prompt)
		return command
	end)
end

-- FIXME need to work out the escaping on the command
--function M.get_pane_command(instance)
--  local pane = M.get_instance_pane(instance)
--  -- TODO refactor in to is_
--  if not pane then
--    log.error("Pane not set")
--    return
--  end
--
--  -- TODO use os.tmpname() to user random file name
--  local command = 'echo !! > /tmp/command; history -d $((HISTCMD-1))'
--  dispatch.execute(pane, command)
--end

function M.edit_last_command(instance)
	M.guarded_send_command(instance, function(func_inst)
		local command = comstack.get_instance_command(func_inst)
		if not command then
			-- TODO capture command some how?
			command = ""
		end

		local edited_command = userInput.get_user_input(command_prompt, command)
		comstack.set_instance_command(func_inst, edited_command)

		return edited_command
	end)
end

function M.scroll(up, instance)
	instance = instance or "1"

	local pane = M.get_instance_pane(instance)
	if not pane then
		log.error("Pane not set")
		return
	end

	dispatch.scroll(pane, up)
end

return M
