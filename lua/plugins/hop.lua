local hop = require("hop")
local jump_target = require("hop.jump_target")
local set = vim.keymap.set

local hint_char1_and_then = function(and_then_func)
  return function()
    local opts = hop.opts
    local c = hop.get_input_pattern('Hop 1 char: ', 1)
    local generator = jump_target.jump_targets_by_scanning_lines
    hop.hint_with_callback(
    generator(jump_target.regex_by_case_searching(c, true, opts)),
    opts,
    function(jt)
      hop.move_cursor_to(jt.window, jt.line + 1, jt.column - 1, opts.hint_offset)
      and_then_func()
    end
    )
  end
end

hop.setup({
  keys = "etovxdygfblzhckisuran",
})

set("n", "<leader>jj", "<CMD>HopChar1<CR>", { noremap = true, silent = true })
set("x", "<leader>jj", "<CMD>HopChar1<CR>", { noremap = true, silent = true })
set("n", "<leader>/", "<CMD>HopPattern<CR>", { noremap = true, silent = true })

set("n", "<leader>jd",hint_char1_and_then(require("telescope.builtin").lsp_definitions), { noremap = true, silent = true })
set("n", "<leader>jD",hint_char1_and_then(vim.lsp.buf.declaration), { noremap = true, silent = true })
set("n", "<leader>ji",hint_char1_and_then(require("telescope.builtin").lsp_implementations), { noremap = true, silent = true })
set("n", "<leader>jr",hint_char1_and_then(require("telescope.builtin").lsp_references), { noremap = true, silent = true })
set("n", "<leader>jk",hint_char1_and_then(vim.lsp.buf.type_definition), { noremap = true })
-- TODO je don't seem ot trigger the and_then_func
set("n", "<leader>je",hint_char1_and_then(vim.diagnostic.open_float), { noremap = true })

-- Playing with f/F replacement
-- TODO come back to this, HopChar1 is basically all I need along wiht hint_char1_and_then
set("n", "<leader>jf", "<cmd>lua require'hop'.hint_char1({ current_line_only = true })<cr>", {})

