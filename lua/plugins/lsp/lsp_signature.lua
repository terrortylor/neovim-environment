local M = {}

function M.attach(bufnr)
  local cfg = {
    bind = true,
    hint_prefix = "🧙 ",
    floating_window = false,
  }

  require("lsp_signature").on_attach(cfg, bufnr)
end

return M
