local o = vim.opt

o.diffopt = "internal,filler,algorithm:patience,indent-heuristic" -- better diffing

-- wildignore
o.wildmode = "full"
o.wildignorecase = true
o.wildignore = {
  "*.bmp",
  "*.gif",
  "*.ico",
  "*.jpg",
  "*.png",
  "*.ico",
  "*.pdf",
  "*.psd",
  "*/node_modules/*",
  "bower_components/*",
  "*/target/*",
  "*/dist/*",
  "*/build/*",
  "tags",
  "*.session"
}

o.timeoutlen = 1500 -- leader timeout

o.hidden = true -- Allow switching buffers without writing changes
o.autowriteall = true -- autowrite on a handleful of actions

o.scrolloff = 5 -- start scrolling 5 lines from top/bottom
o.splitright = true -- default vertical split to right
o.splitbelow = true -- defualt horizontal split to bottom

o.termguicolors = true -- use terminal gui colours
o.showtabline = 2 -- force always show tab line
o.cursorline = true -- highlight line cursor is on
o.number = true -- show line numbers
o.signcolumn = "yes:2" -- show sign column, set width to two
o.foldenable = false -- disbale autofolding

o.ignorecase = true -- ignore case when searching
o.showmatch = true -- visually show matches as typing
o.inccommand = "nosplit" -- show effects of comand as you type
o.gdefault = true -- uses g flag on substitute by default

o.tags = "./.git/tags;/" -- location to look for tag files

o.spell = false -- turn of spell checking
o.spelllang = "en_gb" -- default spelling locale

o.tabstop = 2 -- number of spaces a tab is worth
o.softtabstop = 0
o.expandtab = true -- use spaces rather than tabs
o.shiftwidth = 2 -- number of spaces to use for indent

-- Force syntax highlighting to sync from start of file
-- as syntax highlighting gets messed up when scrolling larger files
vim.cmd("syn sync fromstart")
vim.cmd("syn sync minlines=20")

if vim.fn.executable("rg") > 0 then
  vim.o.grepprg = "rg --vimgrep --no-heading --smart-case"
end
