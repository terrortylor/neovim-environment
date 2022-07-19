local set = vim.keymap.set

set("n", "<space>fd", "<cmd>wall<cr>", {desc = "save all, this is overwritten in lsp's to format doc also"})
set("n", "<leader>rw", [[:%s/\C\<<c-r><c-w>\>//<left>]], {desc = "Refactoring"})

-- Toggles
set("n", "<leader>t/", ":set hlsearch!<CR>", {desc = "Toggle highlight"})
set("n", "<leader>tc", ":set ignorecase!<CR>", {desc = "Toggle case"})
set("n", "<leader>tn", ":set number!<CR>", {desc = "Toggle line numbers"})
set("n", "<leader>tr", ":set relativenumber!<CR>", {desc = "Toggle releative numbers"})
set("n", "<leader>ts", ":set spell!<CR>", {desc = "Toggle spelling"})
set("n", "<F2>", ":set paste!<CR>", {desc = "Toggle paste mode"})

-- Window Resizing
-- TODO can these take a count?
set("n", "<leader>=", ":vertical resize +10<CR>", {desc = "resize window vertically by 10"})
set("n", "<leader>-", ":vertical resize -10<CR>", {desc = "resize window vertically by -10"})
set("n", "<leader>_", ":resize -10<CR>", {desc = "resize window by 10"})
set("n", "<leader>+", ":resize +10<CR>", {desc = "resize window by -10"})
set("n", "<c-y>", "5<c-y>", {desc = "Move window up by 5 lines"})
set("n", "<c-e>", "5<c-e>", {desc = "Move window down by 5 lines"})
-- Open file under cursor in vertical split
set("n", "gsf", ":vertical wincmd f<CR>", {desc = "open file under cursor in vertical split"})
set("n", "ghf", ":wincmd f<CR>", {desc = "open file under cursor in split"})
set("n", "gtf", "mt<CMD>tabnew % <CR> `t <CMD>normal gf<CR>", {desc = "open file under cursor in new tab"})

-- Tab Management
set("n", "[T", ":tabfirst<CR>", {desc = "go to first tab"})
set("n", "]t", ":tabnext<CR>", {desc = "go to last tab"})
set("n", "[t", ":tabprev<CR>", {desc = "go to next tab"})
set("n", "]T", ":tablast<CR>", {desc = "go to previous tab"})
set("n", "<leader>1", ":1tabnext<CR>", {desc = "go to tab 1"})
set("n", "<leader>2", ":2tabnext<CR>", {desc = "go to tab 2"})
set("n", "<leader>3", ":3tabnext<CR>", {desc = "go to tab 3"})
set("n", "<leader>4", ":4tabnext<CR>", {desc = "go to tab 4"})
set("n", "<leader>5", ":5tabnext<CR>", {desc = "go to tab 5"})
set("n", "<leader>6", ":6tabnext<CR>", {desc = "go to tab 6"})
set("n", "<leader>7", ":7tabnext<CR>", {desc = "go to tab 7"})
set("n", "<leader>8", ":8tabnext<CR>", {desc = "go to tab 8"})
set("n", "<leader>9", ":9tabnext<CR>", {desc = "go to tab 9"})
set("n", "<leader>ct", ":tabclose<CR>", {desc = "close tab"})

-- TODO save and restore mark so as not to override `m`
-- TODO check if nvim tree window and move to a buffer window, then run
set("n", "<leader>nt", "mt:tabnew % <BAR> tabmove <CR>`t")

-- Buffer List
set("n", "[b", ":bprevious<CR>", {desc = "go to previous buffer"})
set("n", "]b", ":bnext<CR>", {desc = "go to next buffer"})
set("n", "<leader>bd", ":lua require'ui.window'.delete_buffer_keep_window()<cr>",
  {desc = "delete buffer but keep window layout"})

-- Arg List
set("n", "[a", ":previous<CR>", {desc = "go to previous buffer in arg list"})
set("n", "]a", ":next<CR>", {desc = "go to next buffer in arg list"})

-- Quickfix
set("n", "<leader>cl", function() require('ui.quickfix').open_list() end, {desc = "Opens first non empty list, location list is local to window"})

set("n", "<leader>cc", function() require('ui.quickfix').close_all() end, {desc = "Close all quicklist windows"})
set("n", "[c", ":cprevious<CR>", {desc = "go to previous item in quickfix list"})
set("n", "]c", ":cnext<CR>", {desc = "go to next item in quickfix list"})

set("n", "<leader>lg", ":Lazygit<CR>", {desc = "Lazygit throw away terminal"})

set("n", "<leader>OO", function() require'ui.buffer'.new_line_no_comment(true) end, {desc = "Insert new line above without a comment"})
set("n", "<leader>oo", function() require'ui.buffer'.new_line_no_comment(false) end, {desc = "Insert new line bellow without a comment"})

-- TODO can this take a count?
set("n", "<leader>q", "@q", {desc = "run the macro in q register"})
set("n", "<leader>mm", "`m", {desc = "jump to the m mark"})

-- TODO move this to function that can identify filetype, source is lua, or vim...
set("n", "<leader>ws", ":w <bar> source %<CR>", {desc = "write and source the current file"})

-- Spelling
-- Fix last incorrect word in insert mode: https://stackoverflow.com/a/16481737
set("i", "<c-f>", "<c-g>u<Esc>[s1z=`]a<c-g>u") -- fix last incorrect work
set("n", "<leader>zz", "1z=", {desc = "Auto select first entry"})

set("n", "gp", "`[v`]", {desc = "Reselect last put"})

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
    -- Also seems to be overwritten with hop?
    set("n", "<leader>/", [[/\<\><left><left>]])

    -- Indent Lines and reselect
    set("v", "<", "<gv", {desc = "Indent left and reselect"})
    set("v", ">", ">gv", {desc = "Indent right and reselect"})
    set("n", "<", "<s-v><<ESC>", {desc = "Indent Line left"})
    set("n", ">", "<s-v>><ESC>", {desc = "Indent line right"})


    -- FIXME the double quote in the rhs breaks formatiing
    set("v", "<leader>rw", [[:%s/\C<c-r>"//<left>]], {desc = "replace default register contents with XXX in selection"})
    set("v", "gy", '"+y', {desc = "yank to system clipboard"})
    set("n", "gy", 'gv"+y', {desc = "select last selection and yank to system clipboard"})

    set("i", "jj", "<ESC>", {desc = "Exit insert mode"})
    set("i", "kk", "<ESC>", {desc = "Exit insert mode"})

    set("i", "<PageUp>", "", {desc = "Disbale pagedown in insert mode, keep hitting by mistake"})
    set("i", "<PageDown>", "", {desc = "Disbale pageup in insert mode, keep hitting by mistake"})

    set("i", "<A-o>", "<C-o>O", {desc = "Add and move to empty line above current one"})

    -- Undo break points
    set("i", ",", ",<c-g>u")
    set("i", ".", ".<c-g>u")
    set("i", "!", "!<c-g>u")
    set("i", "?", "?<c-g>u")
    set("i", "(", "(<c-g>u")
    set("i", "[", "[<c-g>u")
    set("i", "{", "{<c-g>u")

    set("x", "<leader>pro", function() require'ui.buffer'.prototype() end)
    set("t", "<leader><ESC>", "<C-\\><C-n>", {desc = "escape insert mode in terminal"})
    set("t", "<leader>jj", "<C-\\><C-n>", {desc = "escape insert mode in terminal"})
