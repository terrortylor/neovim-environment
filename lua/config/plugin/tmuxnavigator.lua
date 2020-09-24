local util = require("util.config")
local nresil = util.noremap_silent

local global_variables = {
  tmux_navigator_no_mappings         = 1,
  tmux_navigator_disable_when_zoomed = 1,
  tmux_navigator_save_on_switch      = 2,
}

util.set_variables(global_variables)

local nav_maps = {
  ["<c-h>"] = ":TmuxNavigateLeft<CR>",
  ["<c-j>"] = ":TmuxNavigateDown<CR>",
  ["<c-k>"] = ":TmuxNavigateUp<CR>",
  ["<c-l>"] = ":TmuxNavigateRight<CR>",
}

for k, v in pairs(nav_maps) do
  util.create_keymap("n", k, v, nresil)
end
