local M = {}
-- TODO randomly show a"tip"?
-- Where should tips live?
-- tip ideas:
-- change in ci ...
-- ( or ) or b for () block
-- < or > for <> block
-- t for tag block
-- { or } or B for {} block

local saved_window_opts = {}

local function go()
  local save_and_update_window_option = function(opt, value)
    saved_window_opts[opt] = vim.wo[opt]
    vim.wo[opt] = value
  end

  -- shamelessly taken from:
  -- https://github.com/mhinz/vim-startify/blob/master/plugin/startify.vim
  if vim.fn.argc() == 0 and vim.fn.line2byte("$") == -1 then
    print("apply splash")

    -- require('snake').start()
    -- vim.cmd("noautocmd enew")
    vim.api.nvim_buf_set_lines(0, 0, 0, true, { "Some splash screen, yeah" })
    vim.api.nvim_buf_set_name(0, " ")
    vim.bo.filetype = "splash"
    -- TODO hide tab and status line?
    -- vim.o.showmode=false
    vim.bo.bufhidden = "wipe"
    vim.bo.modified = false
    vim.bo.buflisted = false
    save_and_update_window_option("colorcolumn", "")
    -- vim.bo.foldlevel=999
    -- vim.bo.foldcolumn=0
    -- vim.bo.matchpairs=false
    -- vim.bo.cursorcolumn=false
    -- vim.bo.cursorline=false
    save_and_update_window_option("list", false)
    save_and_update_window_option("number", false)
    save_and_update_window_option("relativenumber", false)
    save_and_update_window_option("spell", false)
    save_and_update_window_option("signcolumn", "no")
    save_and_update_window_option("wrap", false)
    vim.bo.swapfile = false
    -- vim.bo.synmaxcol&
    vim.bo.buftype = "nofile"

    local buf = vim.fn.bufnr("%")
    vim.cmd("autocmd BufUnload <buffer=" .. buf .. "> ++once lua require('ui.splash').cleanup()")
  end
end

local function highlighting() end

function M.cleanup()
  for k, v in ipairs(saved_window_opts) do
    vim.wo[k] = v
  end
end

function M.setup()
  local ag = vim.api.nvim_create_augroup("spash_screen", { clear = true })
  vim.api.nvim_create_autocmd("VimEnter", {
    pattern = "*",
    callback = function()
      go()
    end,
    once = true,
    group = ag,
  })
  vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "",
    callback = function()
      highlighting()
    end,
    group = ag,
  })
end

return M
