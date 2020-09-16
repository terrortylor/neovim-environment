-- TODO look at some pcall wrapping so everthing doesn't break if single error
local api = vim.api
-- TODO implement 'gf' for lua
local util = require('config.util')

api.nvim_set_var("mapleader", " ")

local wildignore = "*.bmp,*.gif,*.ico,*.jpg,*.png,*.ico"
wildignore = wildignore .. "*.pdf,*.psd"
wildignore = wildignore .. "node_modules/*,bower_components/*"
wildignore = wildignore .. "tags,*.session"

-- TODO when 0.5 upate to use lua-vim-options
-- TODO move setting to sperate file once 'gf' implemented
local options = {
  -- wildignore
  wildmode       = "full",
  wildignorecase = true,
  wildignore     = wildignore,

  -- leader timeout
  timeoutlen     = 1500,

  -- Defualt folding to indent, open by default
  foldmethod     = "indent",
  foldenable     = false,

  -- Allow switching buffers without writing changes
  hidden         = true,
  autowriteall   = true,

  -- Selling
  spell          = false,
  spelllang      = "en_gb",

  -- Some default window behaviour
  scrolloff      = 5,
  splitright     = true,
  splitbelow     = true,

  -- Visual
  termguicolors  = true,
  showtabline    = 2,
  cursorline     = true,
  number         = true,

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

util.set_options(options)

local buf_options = {
  -- persistent undo
  -- TODO move persistent undo out and top of file so if any issues loading config this can be relied on
  undofile      = true,

  -- Indentation
  tabstop       = 2,
  softtabstop   = 0,
  expandtab     = true,
  shiftwidth    = 2,
}

util.set_buf_options(buf_options)

-- Force syntax highlighting to sync from start of file
-- as syntax highlighting gets messed up when scrolling larger files
api.nvim_command("syn sync fromstart")
api.nvim_command("syn sync minlines=20")

local autogroups = {
  cursor_line_group = {
    {"WinEnter", "*", "setlocal cursorline"},
    {"WinLeave", "*", "setlocal nocursorline"}
  },
  vim_rc_auto_write = {
    -- FIXME call function that only runs update if file exists, i.e. not new
    {"InsertLeave,TextChanged", "*", ":update"}
  },
  remove_trailing_whitespace = {
    {"BufWritePre", "*", [[%s/\s\+$//e]]}
  },
  return_to_last_edit_in_buffer = {
    {"BufReadPost", "*", "lua require('config.function.autocommands').move_to_last_edit()"}
  },
}

util.create_autogroups(autogroups)

if api.nvim_call_function("executable", {"rg"}) > 0 then
  api.nvim_set_option("grepprg", "rg --vimgrep --no-heading --smart-case")
end

local global_variables = {
  markdown_fenced_languages = {'bash=sh', 'sh', 'ruby'}
}

util.set_variables(global_variables)

require('config.abbreviations')
require('config.mappings')
require('config.commands')

-- Plugins
require('config.plugin.nerdtree')
require('config.plugin.ctrlp')
require('config.plugin.gutentags')
require('config.plugin.tmuxnavigator')
require('config.plugin.ultisnips')

-- Custom Plugins
require('git').setup()
require('config.plugin.customs')
