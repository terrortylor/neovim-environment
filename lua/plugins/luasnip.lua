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
  -- package.loaded["luasnip"] = nil
  local ls = require("luasnip")
  -- ls.snippets = {}

  -- enable snipmate stype snippets, and load
  -- from snippets dir
  -- require("luasnip.loaders.from_snipmate").load()

  vim.api.nvim_create_user_command("LuaSnipEdit", edit_ft, { force = true })

  -- require("luasnip").config.setup({store_selection_keys="<Tab>"})

  -- function _G.snippets_clear(printMessage)
  print("in snippet")
  require("plenary.reload").reload_module("./lua/snippets")
  for _, ft_path in ipairs(vim.api.nvim_get_runtime_file("lua/snippets/*.lua", true)) do
    local ft = vim.fn.fnamemodify(ft_path, ":t:r")
    print("filetype: " .. ft)
    package.loaded["snippets." .. ft] = nil
    ls.snippets[ft] = require("snippets." .. ft)
    -- require("luasnip.loaders.from_snipmate").load({ include = { ft } })
  end

  -- if printMessage then
  print("Snippets Reloaded! 🧟")
  -- end
  -- end

  require("luasnip.loaders.from_snipmate").load()
  -- require("luasnip.loaders.from_snipmate").lazy_load()
  -- _G.snippets_clear(false)

  -- vim.cmd([[
  -- augroup snippets_clear
  -- au!
  -- au BufWritePost ~/.config/nvim/snippets/*.snippets lua _G.snippets_clear(true)
  -- au BufWritePost ~/.config/nvim/lua/snippets/*.lua lua _G.snippets_clear(true)
  -- augroup END
  -- ]])
end

function M.setup()
  -- setup_snippets()
end

return M
