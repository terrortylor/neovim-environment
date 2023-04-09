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
        vim.cmd("edit ~/.config/nvim/luasnippets/" .. ft .. ".lua")
      end
      -- TODO on buffer change/close then re-run the setup() below to reload
    end
  end)
end

function M.setup()
  vim.api.nvim_create_user_command("LuaSnipEdit", edit_ft, { force = true })
  require("luasnip.loaders.from_snipmate").lazy_load()
  require("luasnip.loaders.from_lua").lazy_load({ paths = "./luasnippets" })
  vim.keymap.set("i", "<c-j>", function()
    require("luasnip").jump(1)
  end, { desc = "luasnip next" })
  vim.keymap.set("i", "<c-k>", function()
    require("luasnip").jump(-1)
  end, { desc = "luasnip previous" })
end

return M
