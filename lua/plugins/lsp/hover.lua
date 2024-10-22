return {
  {
    "lewis6991/hover.nvim",
    keys = {
      { "KK", ':lua require("hover").hover()<cr>', desc = "hover.nvim" },
      { "gKK", ':lua require("hover").hover_select()<cr>', desc = "hover.nvim (select)" },
    },
    opts = {
      init = function()
        -- Require providers
        require("hover.providers.lsp")
        -- require('hover.providers.gh')
        -- require('hover.providers.gh_user')
        -- require('hover.providers.jira')
        -- require('hover.providers.man')
        require("hover.providers.dictionary")
      end,
      preview_opts = {
        border = nil,
      },
      -- Whether the contents of a currently open hover window should be moved
      -- to a :h preview-window when pressing the hover keymap.
      preview_window = false,
      title = true,
    },
  },
}
