local address = vim.fn.tempname()
print("temp address: " .. address)

vim.fn.serverstart(address)

-- https://pkg.go.dev/github.com/neovim/go-client/nvim#Batch.Command
-- https://github.com/jesseduffield/lazygit/issues/1591o
-- luacheck: ignore
-- https://github.com/ugi-coding-community/awesome-for-beginners-language-c-codetronaut/blob/9f81acc076779f891160423657cc35e6ac37c3e6/test/functional/provider/nodejs_spec.lua
