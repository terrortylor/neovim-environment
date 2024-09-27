-- Set spelling on as default
vim.opt.spell = true
vim.opt.spelllang = { "en_gb" }

vim.opt.number = false
vim.opt.relativenumber = false

vim.diagnostic.config({
  virtual_text = true,
  signs = false,
  underline = true,
})

local function check_codelens_support()
  local clients = vim.lsp.get_active_clients({ bufnr = 0 })
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
    local clients = vim.lsp.get_active_clients({ bufnr = 0 })
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
