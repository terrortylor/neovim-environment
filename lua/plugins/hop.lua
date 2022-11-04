local hop = require("hop")
local jump_target = require("hop.jump_target")
local set = vim.keymap.set

local hint_char1_and_then = function(and_then_func)
  return function()
    local opts = hop.opts
    local c = hop.get_input_pattern("Hop 1 char: ", 1)
    local generator = jump_target.jump_targets_by_scanning_lines
    hop.hint_with_callback(generator(jump_target.regex_by_case_searching(c, true, opts)), opts, function(jt)
      hop.move_cursor_to(jt.window, jt.line + 1, jt.column - 1, opts.hint_offset)
      and_then_func()
    end)
  end
end

hop.setup({
  keys = "etovxdygfblzhckisuran",
})

local file_type_definition = function()
  local bf = vim.b.local_hop_definition
  if bf then
    bf()
  else
    if #vim.lsp.buf_get_clients(0) > 0 then
      require("telescope.builtin").lsp_definitions()
    end
  end
end

set("n", "s", "<CMD>HopChar1<CR>", { noremap = true, silent = true })
set("n", "<leader>jj", "<CMD>HopChar1<CR>", { noremap = true, silent = true })
set("x", "<leader>jj", "<CMD>HopChar1<CR>", { noremap = true, silent = true })
set("n", "<leader>/", "<CMD>HopPattern<CR>", { noremap = true, silent = true })

set("n", "<leader>jd", hint_char1_and_then(file_type_definition), { noremap = true, silent = true })
set("n", "<leader>jD", hint_char1_and_then(vim.lsp.buf.declaration), { noremap = true, silent = true })
set(
  "n",
  "<leader>ji",
  hint_char1_and_then(require("telescope.builtin").lsp_implementations),
  { noremap = true, silent = true }
)
set(
  "n",
  "<leader>jr",
  hint_char1_and_then(require("telescope.builtin").lsp_references),
  { noremap = true, silent = true }
)
set("n", "<leader>jk", hint_char1_and_then(vim.lsp.buf.type_definition), { noremap = true })
-- TODO je don't seem ot trigger the and_then_func
set("n", "<leader>je", hint_char1_and_then(vim.diagnostic.open_float), { noremap = true })

-- Playing with f/F replacement
-- TODO come back to this, HopChar1 is basically all I need along wiht hint_char1_and_then
set("n", "<leader>jf", "<cmd>lua require'hop'.hint_char1({ current_line_only = true })<cr>", {})


-- remote change/delete text objects
local default_text_objects = {
  'w', 'W', 's', 'p', '[', ']', '(', ')', 'b',
  '>', '<', 't', '{', '}', 'B', '"', '\'', '`'
}

for _,v in ipairs(default_text_objects) do
  set("n", "cir" .. v, hint_char1_and_then(function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('ci'..v, true, false, true), "n", true)
  end), { noremap = true })

  set("n", "dir" .. v, hint_char1_and_then(function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('di'..v, true, false, true), "n", true)
  end), { noremap = true })
end

set("n", "cirq", hint_char1_and_then(function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('ci"', true, false, true), "n", true)
end), { noremap = true })

set("n", "dirq", hint_char1_and_then(function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('di"', true, false, true), "n", true)
end), { noremap = true })
