local ag = vim.api.nvim_create_augroup("push_notes", { clear = true })
vim.api.nvim_create_autocmd("VimLeave", {
  pattern = "*/personal-workspace/notes/*",
  command = "!~/personal-workspace/notes/push.sh",
  group = ag,
})

