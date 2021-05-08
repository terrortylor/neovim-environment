local wildignore = "*.bmp,*.gif,*.ico,*.jpg,*.png,*.ico"
wildignore = wildignore .. "*.pdf,*.psd"
wildignore = wildignore .. "*/node_modules/*,bower_components/*"
wildignore = wildignore .. '*/target/*,*/dist/*,*/build/*'
wildignore = wildignore .. "tags,*.session"

local function set_options(options)
  for k,v in pairs(options) do
    vim.o[k] = v
  end
end

local global_options = {
  -- better diff
  diffopt        = "internal,filler,algorithm:patience,indent-heuristic",

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
  -- completeopt    = "menuone,preview,noselect,noinsert",
  completeopt    = "menuone,noselect",
}

set_options(global_options)

-- viml set option sets global and local: https://github.com/nanotee/nvim-lua-guide#using-meta-accessors
local function set_win_options(options)
  for k,v in pairs(options) do
    vim.o[k] = v
    vim.wo[k] = v
  end
end

local win_options = {
  -- Visual
  cursorline     = true,
  number         = true,

  -- Selling
  spell          = false,

  -- enable signcolumn to prevent jumping
  signcolumn     = "yes:2",

  -- disable autofolding
  foldenable = false
}

set_win_options(win_options)

-- viml set option sets global and local: https://github.com/nanotee/nvim-lua-guide#using-meta-accessors
local function set_buf_options(options)
  for k,v in pairs(options) do
    vim.o[k] = v
    vim.bo[k] = v
  end
end

local buf_options = {
  -- Indentation
  tabstop       = 2,
  softtabstop   = 0,
  expandtab     = true,
  shiftwidth    = 2,

  -- Selling
  spelllang      = "en_gb",
}

set_buf_options(buf_options)

-- Force syntax highlighting to sync from start of file
-- as syntax highlighting gets messed up when scrolling larger files
vim.cmd("syn sync fromstart")
vim.cmd("syn sync minlines=20")

if vim.fn.executable("rg") > 0 then
  vim.o.grepprg = "rg --vimgrep --no-heading --smart-case"
end
