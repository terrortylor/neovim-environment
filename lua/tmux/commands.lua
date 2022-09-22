local M = {}

-- table structure
-- {
--   identifier = {
--     pane = NUMBER,
--     command_stack = {
--       "latest command",
--       "previous command"
--     }
--   }
-- }
local commands = {}

function M.clear_identifier(identifier)
commands[identifier] = nil
end


function M.get_identifier(identifier)
return commands[identifier]
end

-- todo tetsts
function M.get_pane_and_command(identifier)
  local com = commands[identifier]
  if not com then
    return nil
  end
  return com.pane, com.command_stack[1]
end

-- todo tests
function M.add_complete_command(identifier, pane, command)
  local com = commands[identifier]
  if com then
    commands[identifier].pane = tonumber(pane)
    M.set_command(identifier, command)
  else
    commands[identifier] = {
      pane = tonumber(pane),
      command_stack = {
        command
      }
    }
  end
end

-- todo tests
function M.set_command(identifier, command)
  local com = commands[identifier]
  if com then
    table.insert(com.command_stack, 1, command)
  end
end

return M
