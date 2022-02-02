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
      vim.cmd("edit ~/.config/nvim/snippets/"..item..".snippets")
    end
  end)
end

local function setup_snippets()
  local ls = require("luasnip")

  -- enable snipmate stype snippets, and load
  -- from snippets dir
  require("luasnip.loaders.from_snipmate").load()

  vim.api.nvim_add_user_command("LuaSnipEdit", edit_ft, {force = true})

  -- require("luasnip").config.setup({store_selection_keys="<Tab>"})

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

    require("luasnip.loaders.from_snipmate").load()
  end

  _G.snippets_clear()

  vim.cmd [[
  augroup snippets_clear
  au!
  au BufWritePost ~/.config/nvim/snippets/*.snippets lua _G.snippets_clear()
  augroup END
  ]]
end

function  M.setup()
  setup_snippets()
end

return M
