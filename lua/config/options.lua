-- TODO look at some pcall wrapping so everthing doesn't break if single error
local api = vim.api

-- TODO implement 'gf' for lua
local util = require('util.config')

local wildignore = "*.bmp,*.gif,*.ico,*.jpg,*.png,*.ico"
wildignore = wildignore .. "*.pdf,*.psd"
wildignore = wildignore .. "node_modules/*,bower_components/*"
wildignore = wildignore .. "tags,*.session"

-- TODO when 0.5 upate to use lua-vim-options
-- TODO move setting to sperate file once 'gf' implemented
local global_options = {
  -- wildignore
  wildmode       = "full",
  wildignorecase = true,
  wildignore     = wildignore,

  -- leader timeout
  timeoutlen     = 1500,

  -- Allow switching buffers without writing changes
  hidden         = true,
  autowriteall   = true,

  -- Some default window behaviour
  scrolloff      = 5,
  splitright     = true,
  splitbelow     = true,

  -- Visual
  termguicolors  = true,
  showtabline    = 2,

  -- Searching
  ignorecase     = true,
  showmatch      = true,
  inccommand     = "nosplit",
  gdefault       = true,

  -- Tags (navigation)
  tags           = "./.git/tags;/",

  -- Completion Options
  completeopt    = "menuone,preview,noselect,noinsert",
}

util.set_options(global_options)

local win_options = {
  -- Visual
  cursorline     = true,
  number         = true,

  -- Selling
  spell          = false,

  -- enable signcolumn to prevent jumping
  signcolumn     = "yes",
}

util.set_win_options(win_options)

local buf_options = {
  -- persistent undo
  -- TODO move persistent undo out and top of file so if any issues loading config this can be relied on
  undofile      = true,

  -- Indentation
  tabstop       = 2,
  softtabstop   = 0,
  expandtab     = true,
  shiftwidth    = 2,

  -- Selling
  spelllang      = "en_gb",
}

-- viml set option sets global and local: https://github.com/nanotee/nvim-lua-guide#using-meta-accessors
util.set_buf_options(buf_options)
util.set_options(buf_options)

-- Force syntax highlighting to sync from start of file
-- as syntax highlighting gets messed up when scrolling larger files
api.nvim_command("syn sync fromstart")
api.nvim_command("syn sync minlines=20")

if api.nvim_call_function("executable", {"rg"}) > 0 then
  api.nvim_set_option("grepprg", "rg --vimgrep --no-heading --smart-case")
end
