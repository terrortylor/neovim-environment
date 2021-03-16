local M = {}

M.instance_commands = {}

--- Adds a command to a key=command (stack) map
-- Adds commands to a mapped list, adds new map list if one doesn't exist
-- Doesn't overwrite old commands for historic reasons
-- @param instance string: instance number to add command to
-- @param command string: command to add to instance's list of commands sent
function M.set_instance_command(instance, command)
  if type(instance) == "number" then
    instance = ""..instance..""
  end

  local stack = M.instance_commands[instance]
  if stack then
    table.insert(stack, command)
  else
    stack = {command}
    M.instance_commands[instance] = stack
  end
end

--- Gets last command on instance's stack or returns nil
-- @param instance string: instance number stack to get command from
-- @returns string or nil: string representing a command or nil
function M.get_instance_command(instance)
  -- TODO add test about casting here
  if type(instance) == "number" then
    instance = ""..instance..""
  end

  local commands = M.instance_commands[instance]
  if not commands then
    return nil
  end
  -- Return last item, top of stack
  return commands[#commands]
end

--- Gets all commands on instance's stack or returns nil
-- @param instance string: instance number stack to get command from
-- @returns table or nil: a table list of of commands or nil
function M.get_instance_history(instance)
  local commands = M.instance_commands[instance]
  if not commands then
    return nil
  end
  return commands
end

return M
