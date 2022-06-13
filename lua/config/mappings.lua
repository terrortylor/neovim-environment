-- local m = require("util.bridge")
-- m.nnoremap("<leader>rw", [[:%s/\C\<<c-r><c-w>\>//<left>]], "Replace word under cursor")

-- -- Toggles
-- m.nmap("<leader>t/", ":set hlsearch!<CR>", "Toggle highlight")
-- m.nmap("<leader>tc", ":set ignorecase!<CR>", "Toggle case")
-- m.nmap("<leader>tn", ":set number!<CR>", "Toggle line numbers")
-- m.nmap("<leader>tr", ":set relativenumber!<CR>", "Toggle releative numbers")
-- m.nmap("<leader>ts", ":set spell!<CR>", "Toggle spelling")
-- m.nmap("<F2>", ":set paste!<CR>", "Toggle paste mode")

-- -- Window Resizing
-- -- TODO can these take a count?
-- m.nmap("<leader>=", ":vertical resize +10<CR>", "Increase window width")
-- m.nmap("<leader>-", ":vertical resize -10<CR>", "Decrease window width")
-- m.nmap("<leader>_", ":resize -10<CR>", "Decrease window height")
-- m.nmap("<leader>+", ":resize +10<CR>", "Increase window height")

-- -- Move window up and down in chunks
-- m.nnoremap("<c-y>", "5<c-y>", "Override window scrolling  up to 5 line chunks")
-- m.nnoremap("<c-e>", "5<c-e>", "Override window scrolling down to 5 line chunks")

require("util.config").create_mappings({
  n = {
    -- save all, this is overwritten in lsp's to format doc also
    ["<space>fd"] = "<cmd>wall<cr>",
    -- Refactoring
    ["<leader>rw"] = { [[:%s/\C\<<c-r><c-w>\>//<left>]], { noremap = true } },

    -- Toggles
    ["<leader>t/"] = ":set hlsearch!<CR>", -- Toggle highlight
    ["<leader>tc"] = ":set ignorecase!<CR>", -- Toggle case
    ["<leader>tn"] = ":set number!<CR>", -- Toggle line numbers
    ["<leader>tr"] = ":set relativenumber!<CR>", -- Toggle releative numbers
    ["<leader>ts"] = ":set spell!<CR>", -- Toggle spelling
    ["<F2>"] = ":set paste!<CR>", -- Toggle paste mode

    -- Window Resizing
    -- TODO can these take a count?
    ["<leader>="] = ":vertical resize +10<CR>",
    ["<leader>-"] = ":vertical resize -10<CR>",
    ["<leader>_"] = ":resize -10<CR>",
    ["<leader>+"] = ":resize +10<CR>",
    -- Move window up and down in chunks
    ["<c-y>"] = "5<c-y>",
    ["<c-e>"] = "5<c-e>",
    -- Open file under cursor in vertical split
    ["gsf"] = ":vertical wincmd f<CR>",
    ["ghf"] = ":wincmd f<CR>",
    ["gtf"] = "mt<CMD>tabnew % <CR> `t <CMD>normal gf<CR>",

    -- Tab Management
    ["[T"] = ":tabfirst<CR>",
    ["]t"] = ":tabnext<CR>",
    ["[t"] = ":tabprev<CR>",
    ["]T"] = ":tablast<CR>",
    ["<leader>1"] = ":1tabnext<CR>",
    ["<leader>2"] = ":2tabnext<CR>",
    ["<leader>3"] = ":3tabnext<CR>",
    ["<leader>4"] = ":4tabnext<CR>",
    ["<leader>5"] = ":5tabnext<CR>",
    ["<leader>6"] = ":6tabnext<CR>",
    ["<leader>7"] = ":7tabnext<CR>",
    ["<leader>8"] = ":8tabnext<CR>",
    ["<leader>9"] = ":9tabnext<CR>",
    ["<leader>ct"] = ":tabclose<CR>",
    -- TODO save and restore mark?
    ["<leader>nt"] = "mt:tabnew % <BAR> tabmove <CR>`t",

    -- Buffer List
    ["[b"] = ":bprevious<CR>",
    ["]b"] = ":bnext<CR>",
    ["<leader>bd"] = ":lua require'ui.window'.delete_buffer_keep_window()<cr>",

    -- Arg List
    ["[a"] = ":previous<CR>",
    ["]a"] = ":next<CR>",

    -- Quickfix
    -- Opens first non empty list, location list is local to window
    ["<leader>cl"] = "<CMD>lua require('ui.quickfix').open_list()<CR>",
    -- Close all quicklist windows
    ["<leader>cc"] = "<CMD>lua require('ui.quickfix').close_all()<CR>",
    ["[c"] = ":cprevious<CR>",
    ["]c"] = ":cnext<CR>",

    -- Lazygit throw away terminal
    ["<leader>lg"] = ":Lazygit<CR>",

    -- Insert new line without a comment
    ["<leader>O"] = "<CMD>lua require'ui.buffer'.new_line_no_comment(true)<CR>",
    ["<leader>o"] = "<CMD>lua require'ui.buffer'.new_line_no_comment(false)<CR>",

    -- Quick play macro
    -- TODO can this take a count?
    ["<leader>q"] = "@q",
    -- Quick jump to mark
    ["<leader>mm"] = "`m",
    -- TODO move this to function that can identify filetype
    -- Write and source
    ["<leader>ws"] = ":w <bar> source %<CR>",

    -- Spelling

    -- Auto select first entry
    ["<leader>zz"] = "1z=",

    -- Reselect last put
    ["gp"] = "`[v`]",

    -- Indent Line
    ["<"] = "<s-v><<ESC>",
    [">"] = "<s-v>><ESC>",

    -- smart lines, these do break macro's quite often though...
    -- standard behaviour if in recording a macro
    -- TODO neds testing, if recoring a marcro or in a macro should default to j/k not magic gj/gk
    -- ["j"] = {
    --   "(v:count? 'j' : (reg_recording() == '' ? 'gj' : (reg_executing() == '' ? 'gj' : 'k')))",
    --   { noremap = true, silent = true, expr = true },
    -- },
    -- ["k"] = {
    --   "(v:count? 'k' : (reg_recording() == '' ? 'gk' : (reg_executing() == '' ? 'gk' : 'k')))",
    --   { noremap = true, silent = true, expr = true },
    -- },
    -- TODO this isn't really used any more is it...
    ["<leader>/"] = [[/\<\><left><left>]],
  },
  v = {
    -- Indent Lines and reselect
    ["<"] = "<gv",
    [">"] = ">gv",

    -- replace default register contents with XXX in selection
    -- FIXME the double quote in the rhs breaks formatiing
    ["<leader>rw"] = { [[:s/\C\<<c-r>"\>//<left>]], { noremap = true } },
    ["gy"] = '"+y',
  },
  i = {
    -- Exit insert mode
    ["jj"] = "<ESC>",

    -- Spelling
    -- Fix last incorrect word in insert mode: https://stackoverflow.com/a/16481737
    -- ["<c-f>"]      = "<c-g>u<Esc>[s1z=`]a<c-g>u",

    -- Disbale pageup/down in insert mode, keep hittin by mistake
    ["<PageUp>"] = "",
    ["<PageDown>"] = "",

    -- Add and move to empty line above current one
    ["<A-o>"] = "<C-o>O",

    -- Undo break points
    [","] = ",<c-g>u",
    ["."] = ".<c-g>u",
    ["!"] = "!<c-g>u",
    ["?"] = "?<c-g>u",
    ["("] = "(<c-g>u",
    ["["] = "[<c-g>u",
    ["{"] = "{<c-g>u",
  },
  x = {
    ["<leader>pro"] = ":lua require'ui.buffer'.prototype()<CR>",
  },
  t = {
    ["<leader><ESC>"] = "<C-\\><C-n>",
    ["<leader>jj"] = "<C-\\><C-n>",
  },
})
