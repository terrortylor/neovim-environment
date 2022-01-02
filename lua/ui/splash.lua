local util = require('util.config')

local M = {}

function M.go()
  -- shamelessly taken from:
  -- https://github.com/mhinz/vim-startify/blob/master/plugin/startify.vim
  if vim.fn.argc() == 0 and vim.fn.line2byte('$') == -1 then
    print("apply splash")


    -- require('snake').start()
    -- vim.cmd("noautocmd enew")
    vim.api.nvim_buf_set_lines(0,0,0, true, {"Some splash screen, yeah"})
    vim.api.nvim_buf_set_name(0, ' ')
    -- TODO hide tab and status line?
    -- vim.o.showmode=false
    vim.bo.bufhidden = "wipe"
    vim.bo.modified = false
    vim.bo.buflisted=false
    -- vim.bo.colorcolumn=""
    -- vim.bo.foldlevel=999
    -- vim.bo.foldcolumn=0
    -- vim.bo.matchpairs=false
    -- vim.bo.cursorcolumn=false
    -- vim.bo.cursorline=false
    -- vim.bo.list=false
    -- TODO these window local options need to be captured and restored
    -- print("wo.number", vim.wo.number)
    vim.wo["number"]=false
    vim.wo["relativenumber"]=false
    vim.wo["spell"]=false
    vim.bo.swapfile=false
    vim.wo["signcolumn"]="no"
    -- vim.bo.synmaxcol&
    -- vim.bo.buftype=nofile
    -- vim.bo.filetype=alpha
    vim.wo["wrap"]=false


  local buf = vim.fn.bufnr("%")
  print("buffer", buf)
  vim.cmd("autocmd BufHidden <buffer=" .. buf .."> ++once lua require('ui.splash').go()")
  end
end

function M.cleanup()
    vim.wo["number"]=true
    print("in here cleanup")
end

function M.setup()
  util.create_autogroups({
    splash_update = {
      {"VimEnter", "* ++once", "lua require('ui.splash').go()"},
    },
    splash_highlights = {
      {"ColorScheme", "*", "lua require('ui.splash').highlighting()"}
    }
  })
end

function M.highlighting()
end

return M
