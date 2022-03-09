-- luacheck: ignore
local M = {}

local function edit_ft()
  -- returns table like {"lua", "all"}
  local fts = require("luasnip.util.util").get_snippet_filetypes()

  -- add mapping for either ft in snipmate format or ft in luasnip (lua) file
  local non_all = {}
  for _, v in ipairs(fts) do
    if v ~= "all" then
      table.insert(non_all, v .. " | snipmate")
      table.insert(non_all, v .. " | luasnip")
    end
  end
  table.insert(non_all, "all | snipmate")
  table.insert(non_all, "all | luasnip")

  vim.ui.select(non_all, {
    prompt = "Select which filetype to edit:",
  }, function(item, idx)
    -- selection aborted -> idx == nil
    if idx then
      local ft, style = item:match("(.*) | (.*)")
      if style == "snipmate" then
        vim.cmd("edit ~/.config/nvim/snippets/" .. ft .. ".snippets")
      else
        vim.cmd("edit ~/.config/nvim/lua/snippets/" .. ft .. ".lua")
      end
    end
  end)
end

local function setup_snippets()
  local ls = require("luasnip")

  -- enable snipmate stype snippets, and load
  -- from snippets dir
  -- require("luasnip.loaders.from_snipmate").load()

  vim.api.nvim_add_user_command("LuaSnipEdit", edit_ft, { force = true })

  -- require("luasnip").config.setup({store_selection_keys="<Tab>"})

  function _G.snippets_clear(printMessage)
    for m, _ in pairs(ls.snippets) do
      -- print("clearing ", m)
      package.loaded["snippets." .. m] = nil
    end
    -- snippets/<FT>.lua files are not clearing
    -- seems that the luasnip snippets are not loaded, registering
    -- until after a snippet it used?
    --     local fts = require("luasnip.util.util").get_snippet_filetypes()
    --     for _, v in pairs(fts) do
    --       -- print("clearing ", v)

    --       package.loaded["snippets."..v] = nil
    --     end
    ls.snippets = setmetatable({}, {
      __index = function(t, k)
        -- print("K", k)
        local ok, m = pcall(require, "snippets." .. k)
        if not ok and not string.match(m, "^module.*not found:") then
          -- print("not loaded")
          error(m)
        end
        -- print(vim.inspect(m))

        t[k] = ok and m or {}

        require("luasnip.loaders.from_snipmate").load({ include = { k } })
        return t[k]
      end,
    })

    if printMessage then
      print("Snippets Reloaded! 🧟")
    end
  end

  _G.snippets_clear(false)

  vim.cmd([[
  augroup snippets_clear
  au!
  au BufWritePost ~/.config/nvim/snippets/*.snippets lua _G.snippets_clear(true)
  au BufWritePost ~/.config/nvim/lua/snippets/*.lua lua _G.snippets_clear(true)
  augroup END
  ]])
end

function M.setup()
  setup_snippets()
end

return M
