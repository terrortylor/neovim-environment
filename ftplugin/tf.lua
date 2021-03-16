local options = {
  commentstring = '# %s',
  formatprg = 'terraform fmt -',
}

for k,v in pairs(options) do
  vim.api.nvim_buf_set_option(0, k, v)
end
