local api = vim.api
local util = require('util.config')
local nresil = util.noremap_silent

local M = {}

-- Define settings
M.mappings = {
  ["<leader>ga"]   = ":<C-u>lua require('alternate').get_alternate_file()<CR>",
}

--- Rules are defined for filetypes:
-- condition    : used to control if alternate file will work on given path
-- direction    : matched on path, if false then transformers are applied v subed for k, otherwise the other way around
-- transformers : used to transform a path between file and alternate file, and back again
M.rules = {
  ["ruby.chef"] = {
    condition = "/cookbooks/(.-)/recipes/",
    -- TODO rename direction to alternate_matcher or something this that
    direction = "_spec%.rb",
    transformers = {
      ["%.rb"] = "_spec%.rb",
      ["/recipes/"] = "/spec/unit/recipes/"
    }
  },
  ["ruby"] = {
    condition = ".*",
    direction = "_spec%.rb",
    transformers = {
      ["%.rb"] = "_spec%.rb",
      ["/lib/"] = "/spec/lib/"
    }
  },
  ["lua"] = {
    condition = "/lua/",
    direction = "_spec.lua",
    -- TODO be nice not to have to escape these? https://stackoverflow.com/questions/9790688/escaping-strings-for-gsub
    transformers = {
      ["%.lua"] = "_spec%.lua",
      ["/lua/"] = "/lua/spec/"
    }
  }
}

-- -- TODO move this to a helper
-- function M.file_exists(filename)
--     local file = io.open(filename, "r")
--     if (file) then
--         -- Obviously close the file if it did successfully open.
--         file:close()
--         return true
--     end
--     return false
-- end

local function transform_path(path, transformers, direction)
  local new_path = path
  for v, k in pairs(transformers) do
    if direction == 0 then
      new_path = new_path:gsub(v, k)
    else
      new_path = new_path:gsub(k, v)
    end
  end
  return new_path
end

function M.get_alternate_file()
  local filetype = api.nvim_buf_get_option(0, "filetype")
  local rules = M.rules[filetype]

  if not rules then
    print("No alternate file rule found for filetype: " .. filetype)
    return
  end

  -- check condition is true and file has alternate
  local path = vim.api.nvim_call_function("expand", {"%:p"})
  if not path:match(rules.condition) then
    return
  end

  local alternate_file = ""
  -- check which direction transformation is to happen
  if path:match(rules.direction) then
    alternate_file = transform_path(path, rules.transformers, 1)
  else
    alternate_file = transform_path(path, rules.transformers, 0)
  end

  -- TODO check file exists
  api.nvim_command("e " .. alternate_file)
end

-- Create commands and setup mappings
-- TODO add test
function M.setup()
  -- Create mappings
  for k, v in pairs(M.mappings) do
    util.create_keymap("n", k, v, nresil)
  end
end

-- export locals for test
if _TEST then
  M._transform_path = transform_path
end

return M
