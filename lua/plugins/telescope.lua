local plug = require("pluginman")
local create_mappings = require("util.config").create_mappings
local c = require('config.colours').c
local hl = require('util.highlights')
local set_highlight = hl.set_highlight
local fg = hl.guifg
local util = require('util.config')

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
    width = width,
    results_height = 12,
    results_title = false,
  })
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
  -- TODO update plugin man to have depedencies so not loaded until they are
  plug.add("nvim-lua/popup.nvim")
  plug.add("nvim-lua/plenary.nvim")

  -- Requires:
  -- * nvim-lua/popup.nvim
  -- * nvim-lua/plenary.vim
  plug.add({
    url = "nvim-telescope/telescope.nvim",
    post_handler = function()

      util.create_autogroups({
        telescope_highlights = {
          {"ColorScheme", "*", "lua require('plugins.telescope').highlighting()"}
        }
      })

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
  })

  -- adds github pull integration into telescope
  -- Requires:
  -- * nvim-telescope/telescope.nvim
  plug.add('nvim-telescope/telescope-github.nvim')
end

function M.highlighting()

  set_highlight("TelescopeSelection", fg(c.blue1))
  set_highlight("TelescopeSelectionCaret", fg(c.green2))
  set_highlight("TelescopeMultiSelection", fg(c.blue1))
  set_highlight("TelescopeNormal", fg(c.gandalf))

  set_highlight("TelescopeBorder", fg(c.yellow2))
  set_highlight("TelescopePromptBorder", fg(c.green2))
  set_highlight("TelescopeResultsBorder", fg(c.yellow1))
  set_highlight("TelescopePreviewBorder", fg(c.yellow1))

  set_highlight("TelescopeMatching", fg(c.green2))
  set_highlight("TelescopePromptPrefix", fg(c.red1))

end

return M

