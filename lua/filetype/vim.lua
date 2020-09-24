local api = vim.api
local util = require('util.config')

local M = {}

function M.fold_options()
  local options = {
    foldmethod = "marker",
    foldenable = true,
    fillchars  = "fold: ",
    -- foldtext   = "lua require('filetype.vim.fold').foldtext()",
    foldtext   = "MyVimrcFoldText()",
  }
  util.set_win_options(options)
end

function M.foldtext()
end

-- TODO this could be better?
-- Ilike module as can test easily, but shoud tere always be a setup method?
M.fold_options()
-- return M
