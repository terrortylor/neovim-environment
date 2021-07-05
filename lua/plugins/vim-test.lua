local plug = require("pluginman")

function _G.my_strategy(cmd)
  print("called my strategy: ", cmd)
end

plug.add({
  url = "vim-test/vim-test",
  post_handler = function()
    vim.api.nvim_set_var("test#strategy", "neovim")
    -- vim.g["test#custom_strategies"] = {custom = function() print("test") end}
    -- vim.api.nvim_set_var("test#custom_strategies", {custom = v:lua.my_strategy()})
    -- vim.api.nvim_set_var("test#custom_strategies", {custom = require('plugins.vim-test-strategy').my_strategy})
    -- vim.api.nvim_set_var("test#strategy", "custom")

--     vim.cmd [[
--     let g:test#custom_strategies = {'echo': function('lua my_strategy')}
-- let g:test#strategy = 'echo'
--     ]]
    require('util.config').create_mappings({
      n = {
        ["gtf"]     = "<cmd>TestFile<CR>",
        ["gts"]     = "<cmd>TestSuite<CR>",
        ["gtl"]     = "<cmd>TestLast<CR>",
        ["gtt"]     = "<cmd>TestLast<CR>", -- this is just faster
        ["gtn"]     = "<cmd>TestNearest<CR>",
      },
    })
  end
})


-- TODO
-- wraper so if run TestFile and not a test file then use alternative to get test file name and run that
-- also add checks so if lsp clients attached and any errors then warn or prompt to continue
