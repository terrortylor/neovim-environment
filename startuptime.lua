-- nvim --cmd 'so startuptime.lua' --startuptime nvim.log
local ffi = require('ffi')
local C = ffi.C

ffi.cdef([[
  typedef void FILE;
  typedef uint64_t proftime_T;

  extern FILE *time_fd;

  void time_msg(const char *mesg, const proftime_T *start);
  void time_push(proftime_T *rel, proftime_T *start);
  void time_pop(proftime_T tp);
]])

if C.time_fd == nil then
  return
end

local function pack(...)
  return select('#', ...), {...}
end

local _require = require

function _G.require(modname)
  if package.loaded[modname] ~= nil then
    return _require(modname)
  end

  local rel_time = ffi.new('proftime_T[1]')
  local start_time = ffi.new('proftime_T[1]')
  local time_fd = C.time_fd
  if time_fd ~= nil then
    C.time_push(rel_time, start_time)
  end

  local n, res = pack(pcall(_require, modname))

  if time_fd ~= nil then
    C.time_msg(('require %s'):format(modname), start_time)
    C.time_pop(rel_time[0])
  end

  if res[1] then
    return unpack(res, 2, n)
  else
    error(res[2])
  end
end
