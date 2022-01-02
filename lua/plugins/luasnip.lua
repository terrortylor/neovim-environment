-- luacheck: ignore
local M = {}

local function edit_ft()
  -- returns table like {"lua", "all"}
  local fts = require("luasnip.util.util").get_snippet_filetypes()
  vim.ui.select(fts, {
    prompt = "Select which filetype to edit:"
  }, function(item, idx)
    -- selection aborted -> idx == nil
    if idx then
      vim.cmd("edit ~/.config/nvim/lua/snippets/"..item..".lua")
    end
  end)
end

local function setup_snippets()
  local ls = require("luasnip")

  function _G.snippets_clear()
    for m, _ in pairs(ls.snippets) do
      package.loaded["snippets."..m] = nil
    end
    ls.snippets = setmetatable({}, {
      __index = function(t, k)
        local ok, m = pcall(require, "snippets." .. k)
        if not ok and not string.match(m, "^module.*not found:") then
          error(m)
        end
        t[k] = ok and m or {}
        return t[k]
      end
    })
  end

  _G.snippets_clear()

  vim.cmd [[
  augroup snippets_clear
  au!
  au BufWritePost ~/.config/nvim/lua/snippets/*.lua lua _G.snippets_clear()
  augroup END
  ]]

  vim.api.nvim_add_user_command("LuaSnipEdit", edit_ft, {force = true})

  require("luasnip").config.setup({store_selection_keys="<Tab>"})
end

local function setup_keymaps()

  vim.cmd [[
  imap <silent><expr> <c-k> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<c-k>'
  inoremap <silent> <c-j> <cmd>lua require('luasnip').jump(-1)<CR>

  imap <silent><expr> <C-l> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-l>'

  snoremap <silent> <c-k> <cmd>lua require('luasnip').jump(1)<CR>
  snoremap <silent> <c-j> <cmd>lua require('luasnip').jump(-1)<CR>
]]

end

function  M.setup()
  setup_snippets()
  setup_keymaps()
end

return M
