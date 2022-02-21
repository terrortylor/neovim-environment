-- npm i -g bash-language-server

require('util.health').register_required_binary("bash-language-server", "Reqiured for LSP config, check NVM started 'source startNVM'")

require'lspconfig'.bashls.setup{}
