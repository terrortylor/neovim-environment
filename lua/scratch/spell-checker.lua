local corrections = vim.fn.spellsuggest("telefone")

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local previewers = require("telescope.previewers")

local previewer = function(opts)
  -- return previewers.new()
  return previewers.new_buffer_previewer({
    title = opts.preview_title,
    get_buffer_by_name = function(_, entry)
      return "spell-checker.lua"
    end,
    define_preview = function(self, entry)
      -- print("entry file", entry.value.file)
      previewers.buffer_previewer_maker(entry.value.file, self.state.bufnr, {
        bufname = self.state.bufname,
        winid = self.state.winid,
        preview = opts.preview,
        callback = function(bufnr)
          pcall(vim.api.nvim_win_set_cursor, self.state.winid, { entry.value.line_nr, 0 })
          vim.api.nvim_buf_call(bufnr, function()
            vim.cmd "norm! zz"
          end)
        end,
      })
    end,
  })
end

local generate_links = function()
  local results = {}
  for _, word in pairs(corrections) do
    local entry = {}
    entry.correction = word
    entry.file = "~/personal-workspace/vim-environment/lua/scratch/spell-checker.lua"
    entry.line_nr = 40
    table.insert(results, entry)
  end
  return results
end

-- our picker function: spellsuggetions
local select = function(prompt_bufnr)
  print("entry: ", P(action_state.get_selected_entry()))
  print("entry index: ", P(action_state.get_selected_entry().index))
  -- assuming on mis-spelled word can do `index`z=
  -- but need word to pass to spellsuggest...
  -- could do `]s` as it's circular, then get cWORD
  -- local text = vim.fn.expand("<cWORD>")
  -- use spellbadword(cWORD) and check that result[2] == bad
  actions.close(prompt_bufnr)
end
local spellsuggetions = function(opts)
  opts = opts or {}
  pickers
    .new(opts, {
      prompt_title = "Spell Suggestions",
      -- finder = finders.new_table({
      --   results = corrections,
      -- }),
      finder = finders.new_table({
        results = generate_links(),
        entry_maker = function(entry)
          return {
            value = entry,
            display = entry.correction,
            ordinal = entry.correction,
          }
        end,
      }),
      sorter = conf.generic_sorter(opts),
      previewer = previewer(opts),
      attach_mappings = function(_, map)
        map("i", "<CR>", select)
        map("n", "<CR>", select)
        return true
      end,
    })
    :find()
  end

  -- to execute the function
  -- spellsuggetions()
  spellsuggetions(require("telescope.themes").get_dropdown({}))
