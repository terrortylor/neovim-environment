-- As cofig becomes more and more dependant on external sources
-- this is a helper module to help register and check they are
-- available
-- Exposed as user command set lua/config/commads.lua

local M = {}

M.required_bins = {}

function M.register_required_binary(bin, description)
  if not bin or not description then
    -- luacheck: ignore
    print(
      "can not register required binary, bin and description must be set: bin: "
        .. bin
        .. " description: "
        .. description
    )
    return
  end

  local bin_descs = M.required_bins[bin]
  if bin_descs then
    table.insert(bin_descs, description)
    return
  end

  M.required_bins[bin] = { description }
end

function M.check()
  local health = require("health")
  health.report_start("my-config-health")
  for key, value in pairs(M.required_bins) do
    if vim.fn.executable(key) == 0 then
      for _, v in pairs(value) do
        health.report_info("Missing binary: " .. key .. " : " .. v)
      end
    end
  end
end

return M
