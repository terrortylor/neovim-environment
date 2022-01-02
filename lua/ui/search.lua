-- This is cut down version on vim-cool but with ability to toggle on and off
-- based on issue: https://github.com/neovim/neovim/issues/5581

local M = {}


function M.hlsearch()
  if vim.g.smart_search_enabled then
    local _, col = unpack(vim.api.nvim_win_get_cursor(0))
    local match_pos = vim.fn.match(vim.fn.getline('.'), vim.fn.getreg('/'), col)

    if match_pos == col and vim.o.hlsearch then
      -- if match and hlsearch option is true, just trigger it on again
      -- to re highight if nohlsearch has been called, this is specific
      -- to multiple searches on a single line
       vim.o.hlsearch = true
    elseif match_pos ~= col then
      M.hlstop()
    end
  end
end

function M.hlstop()
  if vim.g.smart_search_enabled then
    if not vim.o.hlsearch or vim.fn.mode() ~= "n" then
      return
    end
    vim.cmd("nohlsearch")
    vim.cmd("redraw")
  end
end

function M.toggle_smart_search()
  local smart_search = vim.g.smart_search_enabled
  smart_search = not smart_search
  vim.g.smart_search_enabled = smart_search
end

function M.setup()
  vim.api.nvim_add_user_command(
    "ToggleSmartSearch",
    require('ui.search').toggle_smart_search,
    {force = true}
  )

  require('util.config').create_autogroups({
    hlmagic = {
      {"CursorMoved", "*", "lua require('ui.search').hlsearch()"},
      {"InsertLeave", "*", "lua require('ui.search').hlstop()"}
    }})

    vim.g.smart_search_enabled = true
end

return M
