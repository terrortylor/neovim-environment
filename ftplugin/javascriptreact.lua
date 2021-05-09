function _G.add_var_to_deconstred_state()
  -- set mark m and yank word under cursor
  -- find line where state is destructured
  -- insert word and delimeter at begining of destructured list
  -- jump back to mark
  require('util.macros').run_macro([[mmyiw?const\s*{.*}\s*=\s*this.state;f{wPa, `m]])
end
vim.api.nvim_buf_set_keymap(0, "n", "<leader>was", ":lua add_var_to_deconstred_state()<CR>", {})
