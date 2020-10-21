local util = require('util.config')
local nresil = util.noremap_silent

local mappings = {
  n = {
    -- Find files
    ["<C-p>"] = ":Files<CR>",
    -- Switch buffers
    ["<leader><space>"]  = ":Buffers<CR>",
  }
}

-- Silent maps
for mode, maps in pairs(mappings) do
  for k, v in pairs(maps) do
    util.create_keymap(mode, k, v, nresil)
  end
end

