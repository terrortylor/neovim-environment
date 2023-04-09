local M = {}

function M.attach(bufnr)
  local cfg = {
    bind = true,
    hint_prefix = "🧙 ",
    floating_window = true,
    toggle_key = "<M-k>",
  }

  require("lsp_signature").on_attach(cfg, bufnr)
end

return M
