local M = {}
-- TODO take a look at highlighing trailing whitespace, and toggling on off:
-- https://vim.fandom.com/wiki/Highlight_unwanted_spaces
-- https://stackoverflow.com/questions/4617059/showing-trailing-spaces-in-vim

local function remove_trailing_whitespace()
  -- some helpful circuit breakers
  if not vim.bo.modifiable then
    return
  end
  if not vim.bo.modified then
    return
  end
  if vim.fn.search("\\s\\+$", "nw") > 0 then
    local pos = vim.api.nvim_win_get_cursor(0)
    vim.cmd([[:keepjumps keeppatterns %s/\s\+$//e]])
    print("Whitespace trimmed! 🧟")
    vim.api.nvim_win_set_cursor(0, pos)
  end
end

local function remove_trailing_whitespace_toggle()
  local toggle = vim.g.trim_whitespace_enabled
  toggle = not toggle
  if toggle then
    vim.api.nvim_create_autocmd("CursorHold", {
      pattern = "*",
      callback = function()
        remove_trailing_whitespace()
      end,
      group = vim.api.nvim_create_augroup("trim_whitespace", { clear = true }),
    })
  else
    vim.api.nvim_del_augroup_by_name("trim_whitespace")
  end
  vim.g.trim_whitespace_enabled = toggle
end

function M.setup()
  -- luacheck: ignore
  vim.api.nvim_create_user_command("ToggleWhitespaceTrim", remove_trailing_whitespace_toggle, { force = true })
  vim.g.trim_whitespace_enabled = false
  remove_trailing_whitespace_toggle()
end

return M
