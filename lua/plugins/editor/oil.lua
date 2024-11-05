return {
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
              keymaps = {
          ["<C-c>"] = false,
          ["q"] = "actions.close",
        },
    },
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
    keys = {
      {
        "-",
        "<CMD>Oil<CR>",
        desc =  "Open parent directory",
      },
    }
  }
}
