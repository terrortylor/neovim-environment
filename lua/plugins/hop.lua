local hint_char1_and_then = function(and_then_func)
  local hop = require("hop")
  local jump_target = require("hop.jump_target")
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

-- remote change/delete text objects
local default_text_objects =
  { "w", "W", "s", "p", "[", "]", "(", ")", "b", ">", "<", "t", "{", "}", "B", '"', "'", "`" }

local generated_keys = {}

for _, v in ipairs(default_text_objects) do
  table.insert(generated_keys, {
    "cir" .. v,
    hint_char1_and_then(function()
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("ci" .. v, true, false, true), "n", true)
    end),
    desc = "jump to and change in: " .. v,
  })

  table.insert(generated_keys, {
    "dir" .. v,
    hint_char1_and_then(function()
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("di" .. v, true, false, true), "n", true)
    end),
    desc = "jump to and delete in: " .. v,
  })
end

table.foreach({
  -- { "s", "<CMD>HopChar1<CR>", desc = "Jump to visible buffer location" },
  { "<leader>jj", "<CMD>HopChar1<CR>", desc = "Jump to visible buffer location" },
  { "<leader>jj", "<CMD>HopChar1<CR>", desc = "In visual mode, jump to visible buffer location" },
  { "<leader>/", "<CMD>HopPattern<CR>", desc = "Search for patter and jump to instance" },
  {
    "<leader>jd",
    hint_char1_and_then(function()
      local bf = vim.b.local_hop_definition
      if bf then
        bf()
      else
        if #vim.lsp.buf_get_clients(0) > 0 then
          require("telescope.builtin").lsp_definitions()
        end
      end
    end),
    desc = "Hop to location and go to definition",
  },
  { "<leader>jD", hint_char1_and_then(vim.lsp.buf.declaration) },
  { "<leader>ji", hint_char1_and_then(require("telescope.builtin").lsp_implementations) },
  { "<leader>jr", hint_char1_and_then(require("telescope.builtin").lsp_references) },
  { "<leader>jk", hint_char1_and_then(vim.lsp.buf.type_definition) },
  -- TODO je don't seem ot trigger the and_then_func
  { "<leader>je", hint_char1_and_then(vim.diagnostic.open_float) },
  -- Playing with f/F replacement
  -- TODO come back to this, HopChar1 is basically all I need along wiht hint_char1_and_then
  { "<leader>jf", "<cmd>lua require'hop'.hint_char1({ current_line_only = true })<cr>" },
  {
    "cirq",
    hint_char1_and_then(function()
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('ci"', true, false, true), "n", true)
    end),
    desc = 'jump to and change in: " alias',
  },
  {
    "dirq",
    hint_char1_and_then(function()
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('di"', true, false, true), "n", true)
    end),
    desc = 'jump to and change in: " alias',
  },
}, function(_, v)
  table.insert(generated_keys, v)
end)

return {
  -- quickly jump to locations in the visible buffer
  {
    "phaazon/hop.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    keys = generated_keys,
    opts = {
      keys = "etovxdygfblzhckisuran",
    },
  },
}
