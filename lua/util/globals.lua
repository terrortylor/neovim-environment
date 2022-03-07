-- Shamelesly copied from:
-- https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/lua/tj/globals.lua
-- luacheck: ignore
P = function(v)
  print(vim.inspect(v))
  return v
end

-- luacheck: ignore
RELOAD = function(...)
  return require("plenary.reload").reload_module(...)
end

-- luacheck: ignore
R = function(name)
  RELOAD(name)
  return require(name)
end
