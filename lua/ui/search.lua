-- This is cut down version on vim-cool but with ability to toggle on and off
-- based on issue: https://github.com/neovim/neovim/issues/5581

local M = {}


function M.hlsearch()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  -- print(row, col)
 local match_pos = vim.fn.match(vim.fn.getline('.'), vim.fn.getreg('/'), col)

 -- print(row, col, match_pos)
 -- if match_pos ~= col then
 if match_pos > 0 and match_pos ~= col then
   M.hlstop()

--  elseif match_pos == col and vim.o.hlsearch then

--    print("match")
--     -- vim.cmd("redraw")
 end
end

function M.hlstop()
  if not vim.o.hlsearch or vim.fn.mode() ~= "n" then
  print("hlstop in return")
    return
  end
    vim.cmd("nohlsearch")
    vim.cmd("redraw")
  print("hlstop after")
end

function M.setup()

  vim.cmd("noremap <expr> <Plug>(StopHL) execute('nohlsearch')[-1]")
  vim.cmd("noremap! <expr> <Plug>(StopHL) execute('nohlsearch')[-1]")
require('util.config').create_autogroups({
  hlmagic = {
    {"CursorMoved", "*", "lua require('ui.search').hlsearch()"},
    {"InsertLeave", "*", "lua require('ui.search').hlstop()"}
  }})

end

return M
