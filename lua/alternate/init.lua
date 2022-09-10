--- A simple module that is used to alternate between two files, that are
-- 'alternates' of each other.
-- In most cases this will be between a file and it's test file companion,
-- but could be to a header file, or compiled version of a template.

local api = vim.api

local M = {}

--- Rules are defined for filetypes:
-- condition    : used to control if alternate file will work on given path
-- direction    : matched on path, if false then transformers are applied v subed for k, otherwise the other way around
-- transformers : used to transform a path between file and alternate file, and back again
M.rules = {
  ["ruby.chef"] = {
    {
      condition = "/cookbooks/(.-)/recipes/",
      -- TODO rename direction to alternate_matcher or something this that
      direction = "_spec.rb",
      transformers = {
        { ".rb", "_spec.rb" },
        { "/recipes/", "/spec/unit/recipes/" },
      },
    },
  },
  ["ruby"] = {
    {
      condition = ".*",
      direction = "_spec.rb",
      transformers = {
        { ".rb", "_spec.rb" },
        { "/lib/", "/spec/lib/" },
      },
    },
  },
  ["lua"] = {
    {
      condition = "/lua/",
      direction = "_spec.lua",
      transformers = {
        { "/lua/", "/lua/spec/" },
        { ".lua", "_spec.lua" },
      },
    },
  },
  ["go"] = {
    {
      condition = ".*",
      direction = "_test.go",
      transformers = {
        { ".go", "_test.go" },
      },
    },
  },
  ["typescript"] = {
    {
      condition = ".ts$",
      direction = ".spec.ts",
      transformers = {
        { ".ts", ".spec.ts" },
      },
    },
  },
  ["javascript"] = {
    {
      condition = ".js$",
      direction = ".spec.js",
      transformers = {
        { ".js", ".spec.js" },
      },
    },
  },
  ["javascriptreact"] = {
    {
      condition = ".jsx$",
      direction = ".spec.jsx",
      transformers = {
        { ".jsx", ".spec.jsx" },
      },
    },
  },
  ["typescriptreact"] = {
    {
      condition = ".tsx$",
      direction = ".test.tsx",
      transformers = {
        { ".tsx", ".test.tsx" },
      },
    },
  },
}

function M.transform_path(path, transformers, to_alternate)
  print("path", path)
  local new_path = path
  for _, pair in pairs(transformers) do
    if to_alternate then
      new_path = new_path:gsub(vim.pesc(pair[1]), pair[2])
    else
      new_path = new_path:gsub(vim.pesc(pair[2]), pair[1])
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

  local match = false
  local i = #rules

  repeat
    local rule = rules[1]
    -- check condition is true and file has alternate
    local path = api.nvim_call_function("expand", { "%:p" })
    if path:match(rule.condition) then
      local alternate_file
      -- check which direction transformation is to happen
      --
      local to_alternate = true
      if path:match(rule.direction) then
        to_alternate = false
      end
      alternate_file = M.transform_path(path, rule.transformers, to_alternate)

      -- TODO check file path exists, if not prompt to create
      vim.cmd("e " .. alternate_file)
      match = true
    end

    i = i + 1
  until match or i > #rules
end

function M.alternate_or_buf_next()
  local reg = vim.fn.getreg("#")
  if reg ~= "" then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-^>", true, false, true), "n", true)
  else
    vim.cmd("bnext")
  end
end

-- Create commands and setup mappings
-- TODO add test
function M.setup()
  local set = vim.keymap.set
  set("n", "<leader>a", require("alternate").alternate_or_buf_next)
  set("n", "<leader>ga", require("alternate").get_alternate_file)
  set("n", "<leader>gsa", function()
    vim.cmd("vsplit")
    require("alternate").get_alternate_file()
  end)
  set("n", "<leader>gha", function()
    vim.cmd("split")
    require("alternate").get_alternate_file()
  end)
end

return M
