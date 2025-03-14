vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
  pattern = "*/personal-workspace/notes/*/*.md",
  callback = function()
    vim.bo.filetype = "markdown.note"
  end
})

