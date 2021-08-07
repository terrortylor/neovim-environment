--- Opens Lazygit in a floating terminal, drops into insert mode.
-- As space is used as leader and have some terminal mappings these are
-- unmapped first and then remapped on exit as a call back

local float = require('ui.window.float')

local is_open
local map_backup

local function capture_and_clear_mappings()
  map_backup = {}

  for _,map in ipairs(vim.api.nvim_get_keymap("t")) do
    local lhs = map.lhs
    -- this is my leader key
     if lhs:match(" ") then
       table.insert(map_backup, map)
       vim.api.nvim_del_keymap("t", map.lhs)
     end
  end
end

local function restore_mappings()
  local make_bool = function(x)
    if x == 1 then return true else return false end
  end

  for _,map in pairs(map_backup) do
   local opts = {
     expr = make_bool(map.expr),
     noremap = make_bool(map.noremap),
     nowait = make_bool(map.nowait),
     silent = make_bool(map.silent)
   }
   vim.api.nvim_set_keymap("t", map.lhs, map.rhs, opts)
  end
end

local function open()
  if not is_open then
    capture_and_clear_mappings()
    local buf = vim.api.nvim_create_buf(false, true)

    local opts = float.gen_centered_float_opts(0.8, 0.8, true)
    local win_tuple = float.open_float(" Lazygit ", true, buf, opts, function() end)

    local  close_lazygit = function()
      restore_mappings()
      float.close_windows(win_tuple[1], win_tuple[2])
      vim.api.nvim_buf_delete(buf, {force = true})
      map_backup = nil
      is_open = nil
    end

    vim.fn.termopen("lazygit", {on_exit = close_lazygit})
    vim.cmd("startinsert!")
  end
end

return {open = open}
