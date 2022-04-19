-- This is cut down version on vim-cool but with ability to toggle on and off
-- based on issue: https://github.com/neovim/neovim/issues/5581

local M = {}

local function hlstop()
  if vim.g.smart_search_enabled then
    if not vim.o.hlsearch or vim.fn.mode() ~= "n" then
      return
    end
    vim.cmd("nohlsearch")
    vim.cmd("redraw")
  end
end

local function hlsearch()
  if vim.g.smart_search_enabled then
    local _, col = unpack(vim.api.nvim_win_get_cursor(0))
    local match_pos = vim.fn.match(vim.fn.getline("."), vim.fn.getreg("/"), col)

    if match_pos == col and vim.o.hlsearch then
      -- if match and hlsearch option is true, just trigger it on again
      -- to re highight if nohlsearch has been called, this is specific
      -- to multiple searches on a single line
      vim.o.hlsearch = true
    elseif match_pos ~= col then
      hlstop()
    end
  end
end

local function toggle_smart_search()
  local smart_search = vim.g.smart_search_enabled
  smart_search = not smart_search
  vim.g.smart_search_enabled = smart_search
end

function M.setup()
  vim.api.nvim_create_user_command("ToggleSmartSearch", toggle_smart_search, { force = true })

  local ag = vim.api.nvim_create_augroup("hlmagic", { clear = true })
  vim.api.nvim_create_autocmd("CursorMoved", {
    pattern = "*",
    callback = function()
      hlsearch()
    end,
    group = ag,
  })
  vim.api.nvim_create_autocmd("InsertLeave", {
    pattern = "*",
    callback = function()
      hlstop()
    end,
    group = ag,
  })

  vim.g.smart_search_enabled = true
end

return M
