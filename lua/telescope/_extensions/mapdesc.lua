local actions = require("telescope.actions")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local conf = require("telescope.config").values
local entry_display = require("telescope.pickers.entry_display")
local action_state = require("telescope.actions.state")


function get_all_available_keymaps()
  local mappings = {}
  for _, v in pairs({"n"}) do
  -- for _, v in pairs({"n", "v", "x", "i", "o", "s", "t"}) do
    local r = vim.api.nvim_get_keymap(v)
    mappings = vim.tbl_deep_extend('force', mappings, r)
  end

  -- filter out mappings with out modes set
  local filtered = {}
  for _, value in ipairs(mappings) do
    if value.mode ~= " " then
      table.insert(filtered, value)
    end
  end
  mappings = filtered

  -- filter out mappings that aren't anything to do with this buffer
  local bufnr = vim.fn.bufnr("%")
  filtered = {}
  for _, value in ipairs(mappings) do
    if value.buffer == 0 or value.buffer ~= bufnr then
      table.insert(filtered, value)
    end
  end
  return filtered
end

local function search(opts)
  local displayer = entry_display.create({
    separator = " ",
    items = {
      { width = 15 },
      { width = 3 },
      { width = 50 },
      { remaining = true },
    },
  })
  local make_display = function(entry)
    local left = entry.value.mode .. " " .. entry.value.lhs
    local middle = ""
    local right = ""
    if entry.value.desc == "" then
      middle = entry.value.rhs
    else
      middle = entry.value.desc
      right = entry.value.rhs
    end
    return displayer({
      left,
      " | ",
      middle,
      right
    })
  end

  pickers.new(opts, {
    prompt_title = "key mappings",
    sorter = conf.generic_sorter(opts),
    finder = finders.new_table({
      results = get_all_available_keymaps(),
      entry_maker = function(mapping)
        -- ordinal should be description if present
        local ordinal
        if not mapping.desc then
          ordinal = mapping.rhs
        else
          ordinal = mapping.desc
        end

        return {
          value = mapping,
          ordinal = ordinal,
          display = make_display,
        }
      end,
    }),
  }):find()
end

return require("telescope").register_extension({
  exports = {
    mapdesc = search,
  },
})
