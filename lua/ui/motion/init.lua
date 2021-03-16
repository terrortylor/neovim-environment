local api = vim.api
local us = require('util.string')
local log = require('util.log')
local M = {}

--- Returns numeric value that is closest to another.
-- Takes the 'cursor' position and two values, returning which even has the smallest difference
-- between it self and the 'cursor' position, taking into account either being nil.
-- @param cursor  The control value we want to find closeness too
-- @param left    A values indicating it's less than the cursor value
-- @param right   A values indicating it's more than the cursor value
-- @return column Column of closest match
function M.compare_closest_number(cursor, left, right)
  -- Now work out which position is closer to the cursor
  if not left then
    if not right then
      return nil
    else
      return right
    end
  elseif not right then
    return left
  else
    local bpos = cursor - left
    local apos = right - cursor
    if bpos <= apos then
      return left
    else
      return right
    end
  end
end

--- Returns the position of the closet matching charecter to the cursor position.
-- Assuming that there may be, may not be and may be multiple matches either side of a given location,
-- the function finds matches of a charecter to a given position in a string and returns the closest
-- to the given 'cursor' position.
-- @param line    The string we are matching on
-- @param char    The charecter we are trying to match in the line
-- @param curpos  The location of the 'cursor' that we want to find the closet matching char too
-- @return column Column of closest match
function M.char_closest_location(line, char, curpos)
  local echar = us.escape(char)

  -- To find the closet match before cursor we have get string before and reverse to find once
  -- as there could be mulitple matches before hand
  local line_before_cursor = line:sub(0, curpos)
  local line_reverse = line_before_cursor:reverse()
  local pos_reverse_line = line_reverse:find(echar)
  local beforepos = nil
  if  pos_reverse_line then
    beforepos = line_reverse:len() - pos_reverse_line + 1
  end
  local afterpos = line:find(echar, curpos)

  return M.compare_closest_number(curpos, beforepos, afterpos)
end

--- Returns the position of the closet matching charecter to the cursor position, where upto two
-- charecters are matched against. Assuming that there may be, may not be and may be multiple matches
-- either side of a given location, the function finds matches of each charecter to a given position
-- in a string and returns the closest to the given 'cursor' position.
-- @param line    The string we are matching on
-- @param lchar   The charecter we are trying to match in the line, if a pair like () then it's the (
-- @param rchar   The charecter we are trying to match in the line, if a pair like () then it's the )
-- @param curpos  The location of the 'cursor' that we want to find the closet matching char too
-- @return (isleft, column) tuple If matching char is left handside (i.e. [ not ]) and column
function M.closest_location(line, lchar, rchar, curpos)
  local lcharpos = M.char_closest_location(line, lchar, curpos)
  local rcharpos = M.char_closest_location(line, rchar, curpos)

  local closest = M.compare_closest_number(curpos, lcharpos, rcharpos)

  -- TODO this doesn't work if currently in a pair, need a way of detecting if in a pair and so
  -- isleft response is direction to matching
  if closest then
    if curpos > closest then
      return true, closest
    else
      return false, closest
    end
  else
    return nil, nil
  end
end

-- TODO currently doesn't take into account that a matching exists
function M.select_object(isaround, lchar, rchar)
  local row,col = unpack(api.nvim_win_get_cursor(0))
  local line = api.nvim_get_current_line()

  local isleft, closest_match = M.closest_location(line, lchar, rchar, col)
  -- col is zero indexed not 1 so so reduce by 1
  closest_match = closest_match - 1
  print(isleft, closest_match)

  if closest_match then
    -- TODO around selects preceeding space if exists
    local ft = 't'
    if isaround then
      ft = 'f'
    else
      if isleft then
        closest_match = closest_match - 1
      else
        closest_match = closest_match + 1
      end
    end

    api.nvim_win_set_cursor(0, {row,closest_match})

    if isleft then
      ft = ft:upper()
      api.nvim_command('normal! v' .. ft .. lchar)
    else
      api.nvim_command('normal! v' .. ft .. rchar)
    end

  else
    log.debug("Closest Match is nil: ", lchar, rchar)
  end

end

return M
