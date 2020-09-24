local util = require('util.config')
local nresil = util.noremap_silent

local noremaps = {
  n = {
    -- Search / highlights
    -- Toggle highlight
    ["<leader>/"]  = ":set hlsearch!<CR>",
    -- Toggle case
    ["<leader>tc"] = ":set ignorecase!<CR>",
    -- Toggle line numbers
    ["<leader>tn"] = ":set number!<CR>",
    ["<leader>tr"] = ":set relativenumber!<CR>",
    ["<F2>"]       = ":set paste!<CR>",

    -- Load vimrc in split
    -- TODO this should be my lua config now
    ["<leader>ev"] = ":vsplit $MYVIMRC<CR>",

    -- Window Resizing
    -- TODO can these take a count?
    ["<leader>="]  = ":vertical resize +10<CR>",
    ["<leader>-"]  = ":vertical resize -10<CR>",
    ["<leader>_"]  = ":resize -10<CR>",
    ["<leader>+"]  = ":resize +10<CR>",
    -- Move window up and down in chunks
    ["<c-y>"]      = "5<c-y>",
    ["<c-e>"]      = "5<c-e>",
    -- Easier alternate file (not custom 'alternate file')
    ["<leader>a"]  = "<c-^>",
    -- Open file under cursor in vertical split
    ["gf"]         = ":vertical wincmd f<CR>",

    -- Tab Management
    ["[T"]         = ":tabfirst<CR>",
    ["]t"]         = ":tabnext<CR>",
    ["[t"]         = ":tabprev<CR>",
    ["]T"]         = ":tablast<CR>",
    ["<leader>1"]  = "1gt<CR>",
    ["<leader>2"]  = "2gt<CR>",
    ["<leader>3"]  = "3gt<CR>",
    ["<leader>4"]  = "4gt<CR>",
    ["<leader>5"]  = "5gt<CR>",
    ["<leader>6"]  = "6gt<CR>",
    ["<leader>7"]  = "7gt<CR>",
    ["<leader>8"]  = "8gt<CR>",
    ["<leader>9"]  = "9gt<CR>",
    ["<leader>ct"] = ":tabclose<CR>",
    ["<leader>nt"] = ":tabnew<CR>",

    -- Buffer List
    ["[b"]         = ":bprevious<CR>",
    ["]b"]         = ":bnext<CR>",
    ["bd"]         = ":call DeleteCurBufferNotCloseWindow()<CR>",

    -- Insert new line without a comment
    ["<leader>O"]  = ":lua require'config.function.editing'.new_line_no_comment(true)<CR>",
    ["<leader>o"]  = ":lua require'config.function.editing'.new_line_no_comment(false)<CR>",

    -- Quick play macro
    -- TODO can this take a count?
    ["<leader>q"]  = "@q",
    -- Quick jump to mark
    ["<leader>mm"] = "`m",
    -- TODO move this to function that can identify filetype
    -- Write and source
    ["<leader>ws"] = ":w <bar> source %<CR>",

    -- Spelling
    -- Auto select first entry
    ["<leader>zz"] = "1z=",
    ["<leader>ts"] = ":set spell!<CR>",

    -- Reselect last put
    ["gp"]         = "`[v`]",

    -- Indent Line
    ["<"]          = "<s-v><<ESC>",
    [">"]          = "<s-v>><ESC>",
  },
  v = {
    -- Indent Lines and reselect
    ["<"]          = "<gv",
    [">"]          = ">gv",
  },
  i = {
    -- Exit insert mode
    ["jj"]         = "<ESC>",

    -- Spelling
    -- Fix last incorrect word in insert mode: https://stackoverflow.com/a/16481737
    ["<c-f>"]      = "<c-g>u<Esc>[s1z=`]a<c-g>u",

    -- Disbale pageup/down in insert mode, keep hittin by mistake
    ["<PageUp>"]   = "",
    ["<PageDown>"] =  "",
  },
  x = {
    ["<leader>pro"] = ":lua require'config.function.editing'.prototype()<CR>"
  },
  t ={
    ["<leader><ESC>"] = "<C-\\><C-n>",
    ["<leader>jj"]    = "<C-\\><C-n>",
  }
}

-- Silent maps
for mode, maps in pairs(noremaps) do
  for k, v in pairs(maps) do
    util.create_keymap(mode, k, v, nresil)
  end
end

local noremaps = {
  n = {
    -- Refactoring
    ["<leader>rw"] = [[:%s/\C\<<c-r><c-w>\>//<left>]],
  },
  v = {
    -- replace default register contents with XXX in selection
    -- FIXME the double quote in the rhs breaks formatiing
    ["<leader>rw"] = [[:s/\C\<<c-r>"\>//<left>]],
  },
}

-- Silent maps
for mode, maps in pairs(noremaps) do
  for k, v in pairs(maps) do
    util.create_keymap(mode, k, v)
  end
end
