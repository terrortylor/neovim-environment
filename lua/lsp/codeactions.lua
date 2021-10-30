local M = {}

-- Lifted from:
-- https://github.com/jose-elias-alvarez/nvim-lsp-ts-utils/blob/main/lua/nvim-lsp-ts-utils.lua
-- and
-- luacheck: ignore
-- https://github.com/nvim-telescope/telescope.nvim/blob/79dc995f820150d5de880c08e814af327ff7e965/lua/telescope/builtin/lsp.lua#L238
function M.fix_first_code_action()
  local params = vim.lsp.util.make_range_params()
  params.context = {
    diagnostics = vim.lsp.diagnostic.get_line_diagnostics()
  }

  vim.lsp.buf_request(0, "textDocument/codeAction", params,
  function(_, _, responses)
    if not responses or not responses[1] then
      print("No code actions available")
      return
    end


    for _, v in ipairs(responses) do
      print("found", vim.inspect(v))
    end

    local val = responses[1]
    if val.edit or type(val.command) == "table" then
      if val.edit then
        vim.lsp.util.apply_workspace_edit(val.edit)
      end
      if type(val.command) == "table" then
        vim.lsp.buf.execute_command(val.command)
      end
    else
      vim.lsp.buf.execute_command(val)
    end
  end)
end

return M
