local M = {}

function M.attach(bufnr)
  local cfg = {
    bind = true,
    handler_opts = {
      border = "rounded",
    },
  }

  require("lsp_signature").on_attach({ cfg, bufnr })
end

return M
