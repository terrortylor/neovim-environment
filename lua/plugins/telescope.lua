local M = {}

local thin_border_chars= {
  { '─', '│', '─', '│', '┌', '┐', '┘', '└'},
  prompt = {"─", "│", " ", "│", '┌', '┐', "│", "│"},
  results = {"─", "│", "─", "│", "├", "┤", "┘", "└"},
  preview = { '─', '│', '─', '│', '┌', '┐', '┘', '└'},
}

function M.dropdown_code_actions()
  local preffered_width = 0.4 -- percentage
  local columns = vim.api.nvim_get_option("columns")
  local width = 100 -- default min width columns

  if width < (columns * preffered_width) then
    width = preffered_width
  end

  require('telescope.builtin.lsp').code_actions({
    borderchars = thin_border_chars,
    sorting_strategy = "ascending",
    layout_strategy = "center",
    layout_config = {
      width = width,
    },
    results_title = false,
  })
end

-- TODO get lsp doucment symbols, filter out methods
function M.lsp_document_methods(opts)
  local pickers = require('telescope.pickers')
  local utils = require('telescope.utils')
  local finders = require('telescope.finders')
  local previewers = require('telescope.previewers')
  local sorters = require('telescope.sorters')


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

  local make_entry = require('telescope.make_entry')

  local conf = require('telescope.config').values
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
    prompt_title = 'LSP Document Symbols',
    finder    = finders.new_table {
      results = locations,
      entry_maker = opts.entry_maker or make_entry.gen_from_lsp_symbols(opts)
    },
    previewer = conf.qflist_previewer(opts),
    sorter = conf.prefilter_sorter{
      tag = "symbol_type",
      sorter = conf.generic_sorter(opts)
    }
  }):find()

end

function M.todo_picker()
  local conf = require('telescope.config').values
  local make_entry = require('telescope.make_entry')
  local finders = require('telescope.finders')
  local pickers = require('telescope.pickers')


  local vimgrep_arguments = conf.vimgrep_arguments
  local search = "TODO"

  local args = vim.tbl_flatten {
    vimgrep_arguments,
    search,
  }
  -- print(vim.inspect(args))

  table.insert(args, '.')

  local opts = {entry_maker = make_entry.gen_from_vimgrep({})}
  pickers.new(opts, {
    prompt_title = 'TODOs',
    finder = finders.new_oneshot_job(args, opts),
    previewer = conf.grep_previewer(opts),
    sorter = conf.generic_sorter(opts),
  }):find()
end

function M.setup()
  local create_mappings = require("util.config").create_mappings

  local mappings = {
    n = {
      ["<leader>ff"] = "<cmd>lua require('telescope.builtin').find_files()<CR>",
      -- TODO add func so if no .git dir is found then open from CWD
      -- luacheck: ignore
      -- https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#falling-back-to-find_files-if-git_files-cant-find-a-git-directory
      ["<c-p>"] = "<cmd>lua require('telescope.builtin').git_files()<CR>",
      ["<leader>fg"] = "<cmd>lua require('telescope.builtin').live_grep()<CR>",
      ["<leader><space>"] = "<cmd>lua require('telescope.builtin').buffers()<CR>",
      ["<leader>fh"] = "<cmd>lua require('telescope.builtin').help_tags()<CR>",
      ["<leader>ft"] = "<cmd>lua require('plugins.telescope').todo_picker()<CR>",
      ["<leader>fs"] = "<cmd>lua require('telescope.builtin.lsp').dynamic_workspace_symbols()<CR>",
      -- todo nice to filter this only to errors
      ["<leader>fe"] = "<cmd>Telescope lsp_workspace_diagnostics<CR>",
    }
  }
  create_mappings(mappings)

  local actions = require('telescope.actions')
  require('telescope').setup{
    defaults = {
      mappings = {
        i = {
          ["<esc>"] = actions.close, -- TODO this isn't working
          ["<c-j>"] = actions.move_selection_next,
          ["<c-k>"] = actions.move_selection_previous,
        }
      }
    }
  }
end

return M

