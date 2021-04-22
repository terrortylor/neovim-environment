local plug = require("pluginman")
local create_mappings = require("util.config").create_mappings
local c = require('config.colours').c
local hl = require('util.highlights')
local set_highlight = hl.set_highlight
local fg = hl.guifg
local util = require('util.config')

local M = {}

function M.dropdown_code_actions()
  local min_width = 100 -- columns
  local preffered_width = 0.4 -- percentage
  local columns = vim.api.nvim_get_option("columns")

  if (columns * preffered_width) < min_width then
    width = 100
  else
    width = preffered_width
  end

  require('telescope.builtin.lsp').code_actions({
    sorting_strategy = "ascending",
    layout_strategy = "center",
    width = width,
    results_height = 12,
    results_title = false,
  }) 
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
          {"ColorScheme", "*", "lua require('config.plugin.telescope').highlighting()"}
        }
      })

      local mappings = {
        n = {
          ["<leader>ff"] = "<cmd>lua require('telescope.builtin').find_files()<CR>",
          -- TODO add func so if no .git dir is found then open from CWD
          ["<c-p>"] = "<cmd>lua require('telescope.builtin').git_files()<CR>",
          ["<leader>fg"] = "<cmd>lua require('telescope.builtin').live_grep()<CR>",
          ["<leader><space>"] = "<cmd>lua require('telescope.builtin').buffers()<CR>",
          ["<leader>fh"] = "<cmd>lua require('telescope.builtin').help_tags()<CR>"
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

