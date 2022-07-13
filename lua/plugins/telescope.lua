local M = {}

require("util.health").register_required_binary("rg", "Used by telescope")

local thin_border_chars = {
  { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
  prompt = { "─", "│", " ", "│", "┌", "┐", "│", "│" },
  results = { "─", "│", "─", "│", "├", "┤", "┘", "└" },
  preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
}

-- TODO get lsp doucment symbols, filter out methods
function M.lsp_document_methods(opts)
  local pickers = require("telescope.pickers")
  local utils = require("telescope.utils")
  local finders = require("telescope.finders")

  local params = vim.lsp.util.make_position_params()
  local results_lsp, err = vim.lsp.buf_request_sync(0, "textDocument/documentSymbol", params)
  if err then
    vim.api.nvim_err_writeln("Error when finding document symbols: " .. err)
    return
  end
  local locations = {}
  local filtered = {}
  -- print(vim.inspect(results_lsp[1].result))
  for _, server_results in pairs(results_lsp[1].result) do
    if server_results.kind == 12 then
      print(server_results.name)
      table.insert(filtered, server_results)
    end
    vim.list_extend(locations, vim.lsp.util.symbols_to_items(filtered, 0) or {})
  end

  local results = utils.quickfix_items_to_entries(locations)

  if vim.tbl_isempty(results) then
    return
  end

  print("length", #results, vim.inspect(results))

  local make_entry = require("telescope.make_entry")

  local conf = require("telescope.config").values
  --   pickers.new(opts, {
  --     prompt    = 'LSP Document Symbols Methods',
  --     finder    = finders.new_table({results = results,
  --           entry_maker = opts.entry_maker or make_entry.gen_from_lsp_symbols(opts)

  --   }),
  --     previewer = previewers.qflist,
  --     sorter = conf.generic_sorter(opts),
  --     -- sorter    = sorters.get_norcalli_sorter(),
  --   }):find()
  opts.ignore_filename = opts.ignore_filename or true
  pickers.new(opts, {
    prompt_title = "LSP Document Symbols",
    finder = finders.new_table({
      results = locations,
      entry_maker = opts.entry_maker or make_entry.gen_from_lsp_symbols(opts),
    }),
    previewer = conf.qflist_previewer(opts),
    sorter = conf.prefilter_sorter({
      tag = "symbol_type",
      sorter = conf.generic_sorter(opts),
    }),
  }):find()
end

function M.todo_picker()
  local conf = require("telescope.config").values
  local make_entry = require("telescope.make_entry")
  local finders = require("telescope.finders")
  local pickers = require("telescope.pickers")

  local vimgrep_arguments = conf.vimgrep_arguments
  local search = "TODO"

  local args = vim.tbl_flatten({
    vimgrep_arguments,
    search,
  })
  -- print(vim.inspect(args))

  table.insert(args, ".")

  local opts = { entry_maker = make_entry.gen_from_vimgrep({}) }
  pickers.new(opts, {
    prompt_title = "TODOs",
    finder = finders.new_oneshot_job(args, opts),
    previewer = conf.grep_previewer(opts),
    sorter = conf.generic_sorter(opts),
  }):find()
end

-- luacheck: ignore
-- https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#falling-back-to-find_files-if-git_files-cant-find-a-git-directory
function M.project_files()
  local opts = {} -- define here if you want to define something
  local ok = pcall(require("telescope.builtin").git_files, opts)
  if not ok then
    require("telescope.builtin").find_files(opts)
  end
end

function M.setup()
  local set = vim.keymap.set
  set("n", "<leader>fr", "<cmd>Telescope current_buffer_fuzzy_find<CR>", {desc = "telescope find in current buffer"})
  -- Nice to have as a command to easily call from CLI
  set("n", "<c-p>", function() require('plugins.telescope').project_files() end, {desc = "telescope open file, either git_files or fallback to CWD"})
  set("n", "<leader>fg", function() require('telescope.builtin').live_grep() end, {desc = "telescope grep project/CWD"})
  set("n", "<leader><space>", function() require('telescope.builtin').buffers() end, {desc = "telescope switch to an open buffer"})
  set("n", "<leader>fh", function() require('telescope.builtin').help_tags() end, {desc = "telescope search tags"})
  set("n", "<leader>ft", function() require('plugins.telescope').todo_picker() end, {desc = "telescope search todo's in CWD"})
  set("n", "<leader>fs", function() require('telescope.builtin.lsp').dynamic_workspace_symbols() end, {desc = "telescope LSP symbols"})
  -- todo nice to filter this only to errors
  set("n", "<leader>fe", "<cmd>Telescope diagnostics<CR>", {desc = "telescope LSP diagnostics"})

  local actions = require("telescope.actions")
  require("telescope").setup({
    defaults = {
      mappings = {
        i = {
          ["<esc>"] = actions.close, -- TODO this isn't working
          ["<c-j>"] = actions.move_selection_next,
          ["<c-k>"] = actions.move_selection_previous,
        },
      },
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown({})
        },
      },
    },
  })

  require("telescope").load_extension("ui-select")

  -- my extensions
  require("telescope").load_extension("mapdesc")
  require("telescope").load_extension("bashrc")
  require("telescope").load_extension("go_src")
  require("telescope").load_extension("awesome_src")
  require("telescope").load_extension("plugin_files")
  require("telescope").load_extension("notes")
end

return M
