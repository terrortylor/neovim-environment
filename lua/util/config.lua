local log = require('util.log')
-- FIXME no tests
local api = vim.api

local M = {}

-- TODO remove once nvim 0.5
function M.set_options(options)
  for k,v in pairs(options) do
    api.nvim_set_option(k, v)
  end
end

-- TODO remove once nvim 0.5
function M.set_buf_options(options, buffer)
  buffer = buffer or 0
  for k,v in pairs(options) do
    api.nvim_buf_set_option(buffer, k, v)
  end
end

-- TODO remove once nvim 0.5
function M.set_win_options(options, window)
  window = window or 0
  for k,v in pairs(options) do
    api.nvim_win_set_option(window, k, v)
  end
end

-- TODO remove once nvim 0.5
function M.set_variables(variables)
  for k,v in pairs(variables) do
    api.nvim_set_var(k, v)
  end
end

function M.create_mappings(mappings, opts, buffer)
  opts = opts or {noremap = true, silent = true}
  local function keymap(...)
    if buffer then
      vim.api.nvim_buf_set_keymap(buffer, ...)
    else
      vim.api.nvim_set_keymap(...)
    end
  end

  for mode, maps in pairs(mappings) do
    for k, v in pairs(maps) do
      if type(v) == 'string' then
        keymap(mode, k, v, opts)
      elseif type(v) == 'table' then
        if #v == 2 then
          keymap(mode, k, v[1], v[2])
        else
          log.error("Mapping not run for lhs: " .. k .. " mode: " .. mode)
        end
      end
    end
  end
end

function M.create_autogroups(definitions)
  for group, definition in pairs(definitions) do
    api.nvim_command('augroup '..group)
    api.nvim_command('autocmd!')
    for _, line in ipairs(definition) do
      -- TODO is flatterning a table here overkill, why not just a line with spaces...?
      local command = table.concat(vim.tbl_flatten{'autocmd', line}, ' ')
      api.nvim_command(command)
    end
    api.nvim_command('augroup END')
  end
end

-- Show highlight group under cursor
-- https://stackoverflow.com/questions/9464844/how-to-get-group-name-of-highlighting-under-cursor-in-vim
function M.show_highlight_group()
  local line,col = unpack(api.nvim_win_get_cursor(0))
  local syn_id = api.nvim_call_function("synID", {line, col, 1})
  if syn_id > 0 then
    local syn_name = api.nvim_call_function("synIDattr", {syn_id, "name"})
    local syn_group_id = api.nvim_call_function("synIDtrans", {syn_id})
    local syn_group_name = api.nvim_call_function("synIDattr", {syn_group_id, "name"})
    print(syn_name .. " -> " .. syn_group_name)
  else
    print("No group info found")
  end
end

return M
