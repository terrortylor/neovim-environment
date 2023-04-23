-- remote change/delete text objects
local default_text_objects =
  { "w", "W", "s", "p", "[", "]", "(", ")", "b", ">", "<", "t", "{", "}", "B", '"', "'", "`" }

local generated_keys = {}

for _, v in ipairs(default_text_objects) do
  table.insert(generated_keys, {
    "cir" .. v,
    ":lua require('plugins.lazy_wrappers.lazy_hop').feedkeys_at_remote('ci" .. v .. "', 'n')<cr>",
    desc = "jump to and change in: " .. v,
  })

  table.insert(generated_keys, {
    "dir" .. v,
    "dir" .. v,
    ":lua require('plugins.lazy_wrappers.lazy_hop').feedkeys_at_remote('di" .. v .. "', 'n')<cr>",
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
    ":lua require('plugins.lazy_wrappers.lazy_hop').hint_lsp_definition()<cr>",
    desc = "Hop to location and go to definition",
  },
  {
    "<leader>jD",
    ":lua require('plugins.lazy_wrappers.lazy_hop').hint_lsp_definition()<cr>",
    desc = "Hop to location and go to declaration",
  },
  {
    "<leader>ji",
    ":lua require('plugins.lazy_wrappers.lazy_hop').hint_lsp_implementations()<cr>",
    desc = "Hop to location and go to implementations",
  },
  {
    "<leader>jr",
    ":lua require('plugins.lazy_wrappers.lazy_hop').hint_lsp_references()<cr>",
    desc = "Hop to location and go to references",
  },
  {
    "<leader>jk",
    ":lua require('plugins.lazy_wrappers.lazy_hop').hint_lsp_type_definition()<cr>",
    desc = "Hop to location and go to type declaration",
  },
  -- -- TODO je don't seem ot trigger the and_then_func
  -- { "<leader>je", hint_char1_and_then(vim.diagnostic.open_float) },
  -- Playing with f/F replacement
  -- TODO come back to this, HopChar1 is basically all I need along wiht hint_char1_and_then
  { "<leader>jf", "<cmd>lua require'hop'.hint_char1({ current_line_only = true })<cr>" },
  {
    "cirq",
    ":lua require('plugins.lazy_wrappers.lazy_hop').feedkeys_at_remote('ciq', 'n')<cr>",
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
