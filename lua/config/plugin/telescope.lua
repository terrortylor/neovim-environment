local plug = require("pluginman")
local create_mappings = require("util.config").create_mappings

-- TODO update plugin man to have depedencies so not loaded until they are
plug.add("nvim-lua/popup.nvim")
plug.add("nvim-lua/plenary.nvim")

-- Requires:
-- * nvim-lua/popup.nvim
-- * nvim-lua/plenary.vim
plug.add({
  url = "nvim-telescope/telescope.nvim",
  post_handler = function()
    local actions = require('telescope.actions')
    require('telescope').setup{
      defaults = {
        mappings = {
          i = {
            ["<c-j>"] = actions.move_selection_next,
            ["<c-k>"] = actions.move_selection_previous,
            ["<esc>"] = actions.close
          }
        }
      }
    }

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
  end
})

-- adds github pull integration into telescope
-- Requires:
-- * nvim-telescope/telescope.nvim
plug.add('nvim-telescope/telescope-github.nvim')
