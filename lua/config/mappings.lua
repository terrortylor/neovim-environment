local util = require('util.config')
local log = require('util.log')
local nresil = util.noremap_silent

local mappings = {
  n = {
    -- Refactoring
    ["<leader>rw"] = {[[:%s/\C\<<c-r><c-w>\>//<left>]], {noremap = true}},
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
    ["<leader>bd"] = ":lua require'ui.window'.delete_buffer_keep_window()<cr>",

    -- Arg List
    ["[a"]         = ":previous<CR>",
    ["]a"]         = ":next<CR>",

    -- Quickfix
    ["[c"]         = ":cprevious<CR>",
    ["]c"]         = ":cnext<CR>",

    -- Insert new line without a comment
    ["<leader>O"]  = ":lua require'ui.buffer'.new_line_no_comment(true)<CR>",
    ["<leader>o"]  = ":lua require'ui.buffer'.new_line_no_comment(false)<CR>",

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

    -- smart lines, these do break macro's quite often though...
    -- TODO is it possible to checkif either recording a macro or running one first?
    --["j"]          = {"(v:count? 'j' : 'gj')", {noremap = true, silent = true, expr = true}},
    --["k"]          = {"(v:count? 'k' : 'gk')", {noremap = true, silent = true, expr = true}},

    -- Comment
    ["gc"]         = ":CommentToggle<cr>",
  },
  v = {
    -- Indent Lines and reselect
    ["<"]          = "<gv",
    [">"]          = ">gv",

    -- replace default register contents with XXX in selection
    -- FIXME the double quote in the rhs breaks formatiing
    ["<leader>rw"] = {[[:s/\C\<<c-r>"\>//<left>]], {noremap = true}},

    -- Comment
    ["gc"]         = ":'<,'>CommentToggle<cr>",
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

    -- Add and move to empty line above current one
    ["<A-o>"]      = "<C-o>O",
  },
  x = {
    ["<leader>pro"] = ":lua require'ui.buffer'.prototype()<CR>"
  },
  t ={
    ["<leader><ESC>"] = "<C-\\><C-n>",
    ["<leader>jj"]    = "<C-\\><C-n>",
  }
}

-- Silent maps
for mode, maps in pairs(mappings) do
  for k, v in pairs(maps) do
    if type(v) == 'string' then
    util.create_keymap(mode, k, v, nresil)
    elseif type(v) == 'table' then
      if #v == 2 then
        util.create_keymap(mode, k, v[1], v[2])
      else
        log.error("Mapping not run for lhs: " .. k .. " mode: " .. mode)
      end
    end
  end
end
