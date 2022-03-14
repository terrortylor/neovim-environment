local M = {}
-- TODO take a look at highlighing trailing whitespace, and toggling on off:
-- https://vim.fandom.com/wiki/Highlight_unwanted_spaces
-- https://stackoverflow.com/questions/4617059/showing-trailing-spaces-in-vim

function M.remove_trailing_whitespace()
  if not vim.bo.modified then
    return
  end
  if vim.fn.search("\\s\\+$", "nw") > 0 then
    local pos = vim.api.nvim_win_get_cursor(0)

    -- TODO
    -- add toggle func to disable
    vim.cmd([[:keepjumps keeppatterns %s/\s\+$//e]])
    print("Whitespace trimmed! 🧟")

    vim.api.nvim_win_set_cursor(0, pos)
  end
end

function M.remove_trailing_whitespace_toggle()
  local toggle = vim.g.trim_whitespace_enabled
  toggle = not toggle
  if toggle then
    require("util.config").create_autogroups({
      trim_whitespace = {
        { "CursorHold", "*", "lua require('ui.buffer.trailing_whitespace').remove_trailing_whitespace()" },
      },
    })
  else
    vim.cmd("autocmd! trim_whitespace")
  end
  vim.g.trim_whitespace_enabled = toggle
end

function M.setup()
  -- luacheck: ignore
  vim.api.nvim_add_user_command(
    "ToggleWhitespaceTrim",
    require("ui.buffer.trailing_whitespace").remove_trailing_whitespace_toggle,
    { force = true }
  )
  vim.g.trim_whitespace_enabled = false
  M.remove_trailing_whitespace_toggle()
end

return M
