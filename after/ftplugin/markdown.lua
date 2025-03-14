-- Set spelling on as default
vim.opt.spell = true
vim.opt.spelllang = { "en_gb" }

-- vim.opt.formatoptions:remove("o")
-- vim.opt.formatoptions = "jtcqlno"
-- vim.opt.textwidth = 100
-- From: http://germaniumhq.com/2020/04/08/2020-04-08-Vim-Auto-Formatting-for-Asciidoc-and-Markdown/
-- Interesting take, and works quite well but not for long links
-- vim.opt.formatoptions = "want"

vim.opt.number = false
vim.opt.relativenumber = false

vim.bo.tabstop = 2
vim.bo.softtabstop = 2
vim.bo.shiftwidth = 2
vim.bo.expandtab = true

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
-- autocmd BufReadPost,FileReadPost * normal zR


-- Attempt to ignore URL's and wiki links etc from spelling
-- https://www.reddit.com/r/neovim/comments/scleu7/comment/hu8195z/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
vim.cmd.syntax([[match PRDiffDel '\w\+\:\/\/\[\w\+\]' contains=@NoSpell]])
-- vim.cmd.syntax([[match match NoSpellUriPython /\w\+/]]) 
-- vim.cmd.syntax([[match match NoSpellUriPython '\w\+:\/\/[^[:space:]]\+']]) 
-- vim.cmd.syntax([[match match NoSpellUriPython \w\+:\/\/[^[:space:\]\]\+ contains=@NoSpell]]) 
-- vim.cmd.syntax("match UrlNoSpell '\w\+:%/\/[^[:space:]]\+' contains=@NoSpell")

vim.diagnostic.config({
  virtual_text = true,
  signs = false,
  underline = true,
})

local function check_codelens_support()
  local clients = vim.lsp.buf_get_clients(0)
  for _, c in ipairs(clients) do
    if c.server_capabilities.codeLensProvider then
      return true
    end
  end
  return false
end

--- Markdown Oxide specifc stuff ---
--- copied form https://oxide.md/README
vim.api.nvim_create_autocmd({ "TextChanged", "InsertLeave", "CursorHold", "LspAttach", "BufEnter" }, {
  buffer = bufnr,
  callback = function()
    if check_codelens_support() then
      vim.lsp.codelens.refresh({ bufnr = 0 })
    end
  end,
})

-- trigger codelens refresh
vim.api.nvim_exec_autocmds("User", { pattern = "LspAttached" })

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("MarkdownOxideDailyCommand", {}),
  callback = function(ev)
    local clients = vim.lsp.buf_get_clients(0)
    for _, c in ipairs(clients) do
      if c.name == "markdown_oxide" then
        vim.api.nvim_create_user_command("Daily", function(args)
          local input = args.args

          vim.lsp.buf.execute_command({ command = "jump", arguments = { input } })
        end, { desc = "Open daily note", nargs = "*" })
        return
      end
    end
  end,
})
--- END Markdown Oxide specifc stuff ---

-- "" Note that o is required by todo list plugin stuff
-- "setlocal formatoptions+=o
-- ""setlocal formatoptions=jtqlnor
-- "
-- "nnoremap <buffer> [h :lua require("ui.buffer.nav").find_next("?", "^#")<CR>
-- "nnoremap <buffer> ]h :lua require("ui.buffer.nav").find_next("/", "^#")<CR>

vim.cmd.iabbrev("<buffer>", "github", "GitHub")
vim.cmd.iabbrev("<buffer>", "gitub", "GitHub")
vim.cmd.iabbrev("<buffer>", "ansible", "Ansible")
vim.cmd.iabbrev("<buffer>", "jenkins", "Jenkins")
vim.cmd.iabbrev("<buffer>", "google", "Google")
vim.cmd.iabbrev("<buffer>", "aws", "AWS")
vim.cmd.iabbrev("<buffer>", "azure", "Azure")
vim.cmd.iabbrev("<buffer>", "cms", "CMS")
vim.cmd.iabbrev("<buffer>", "k8s", "K8s")
vim.cmd.iabbrev("<buffer>", "linux", "Linux")
vim.cmd.iabbrev("<buffer>", "testevovle", "TestEvolve")
vim.cmd.iabbrev("<buffer>", "grafana", "Grafana")
vim.cmd.iabbrev("<buffer>", "influxdb", "InfluxDB")
vim.cmd.iabbrev("<buffer>", "javascript", "JavaScript")
vim.cmd.iabbrev("<buffer>", "typescript", "TypeScript")
vim.cmd.iabbrev("<buffer>", "lastpass", "LastPass")
vim.cmd.iabbrev("<buffer>", "denby", "Denby")

-- "" Manage new line below current line in normal mode
-- "nnoremap <buffer> <Plug>(MarkdownNewLineBellow) o<C-R>=luaeval("require('markdown.tasks').insert_empty_task_box(true)")<CR>
-- "" Manage new line above current line in normal mode
-- "nnoremap <buffer> <Plug>(MarkdownNewLineAbove) O<C-R>=luaeval("require('markdown.tasks').insert_empty_task_box(false)")<CR>
-- "" plug map <buffer>pings not really required at this point... :P
-- "nmap <buffer> <silent> o <Plug>(MarkdownNewLineBellow)
-- "nmap <buffer> <silent> O <Plug>(MarkdownNewLineAbove)
-- "
-- "" Used to mark tasks as not done,start,done
-- "nnoremap <buffer> <Plug>(MarkdownCheckboxNotDone) :lua require('markdown.tasks').set_task_state(' ')<CR>
-- "nnoremap <buffer> <Plug>(MarkdownCheckboxStarted) :lua require('markdown.tasks').set_task_state('o')<CR>
-- "nnoremap <buffer> <Plug>(MarkdownCheckboxDone) :lua require('markdown.tasks').set_task_state('x')<CR>
-- "
-- "nmap <buffer> <leader>mt <Plug>(MarkdownCheckboxNotDone)
-- "nmap <buffer> <leader>ms <Plug>(MarkdownCheckboxStarted)
-- "nmap <buffer> <leader>md <Plug>(MarkdownCheckboxDone)
-- "
-- "inoremap <buffer> <Plug>(MarkdownlistNewLine) <C-O><cmd>lua require('markdown.tasks').handle_carridge_return()<cr>
-- "" TODO why was this added to a ts file?
-- "imap <buffer> <cr> <Plug>(MarkdownlistNewLine)
