return {

  {
    'mistweaverco/kulala.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
  opts = {}
},

  {
    "rest-nvim/rest.nvim",
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
        require("rest-nvim").setup({
          -- _log_level = vim.log.levels.DEBUG,
          response = {
hooks = {format = true},
          },
            -- env = {
            --     pattern = "%.env$"
            -- },
            -- ui = {
            --     keybinds = {
            --         prev = "P",
            --         next = "N",
            --     },
            -- },
        })




-- vim.api.nvim_create_autocmd("FileType", {
--     pattern = "json",
--     callback = function()
-- vim.bo.formatexpr = ""
-- vim.bo.formatprg = "jq"
--     end,
-- })
-- vim.api.nvim_create_autocmd("FileType", {
--     pattern = "problem+json",
--     callback = function()
-- vim.bo.formatexpr = ""
-- vim.bo.formatprg = "jq"
--     end,
-- })

    end,
},


}
