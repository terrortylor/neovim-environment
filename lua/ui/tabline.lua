local c = require('config.colours').c
local hl = require('util.highlights')
local set_highlight = hl.set_highlight
local fg = hl.guifg
local bg = hl.guibg
local lsp_funcs = require('config.lsp.funcs')
local util = require('util.config')

local left_tabline = {}
local left_width = 0
local right_tabline = {}
local right_width = 0

local M = {}

local ignore_filetypes = {
  "qf",
  "help",
  "TelescopePrompt",
  "NvimTree"
}

local function add_left(hl, text)
  table.insert(left_tabline, "%#" .. hl .."#")
  left_width = left_width + string.len(text)
  table.insert(left_tabline, text)
end

local function add_right(hl, text)
  table.insert(right_tabline, "%#" .. hl .."#")
  right_width = right_width + string.len(text)
  table.insert(right_tabline, text)
end

local function right_tl(text)
  right_width = right_width + string.len(text)
  table.insert(right_tabline, text)
end

local function tab_markers()
  local num_tabs = vim.fn.tabpagenr('$')
  local curent_tab = vim.fn.tabpagenr()

  for t = 1, num_tabs, 1 do
    -- handle if tab is selected, and tab number
    if t == curent_tab then
      add_left("TabLineSel", "["..t.."] ")
    else
      add_left("TabLine", " " .. t .. "  ")
    end

    -- TODO make this toggalable
    -- show active window buf name
    local tabwinnr = vim.fn.tabpagewinnr(t)
    local tab_bufs = vim.fn.tabpagebuflist(t)
    -- TODO not path + filename, just filename
    -- table.insert(sl, vim.fn.bufname(tab_bufs[tabwinnr]))
    -- left_tl(" ")

    add_left("TabLineFill", "")
  end
end

local function diagnostics()
  if #vim.lsp.buf_get_clients(0) > 0 then
    local total_diagnostics = lsp_funcs.get_all_diagnostic_count()
    add_right("TabLineDiagError", " E: ")
    add_right("TabLine", total_diagnostics.errors)
    add_right("TabLineDiagWarn", " W: ")
    add_right("TabLine", total_diagnostics.warnings)
  end
end

local function filetype()
  local filetype = vim.api.nvim_buf_get_option(0, "filetype")
  if filetype == "" then
    return
  end

  local skip = false
  for _,ft in pairs(ignore_filetypes) do
    if ft == filetype then
      skip = true
      break
    end
  end

  if not skip then
    add_right("TabLineAtomHeader", "FT: ")
    add_right("TabLine", filetype)
  end
end

local function tabline()
  -- reset tabline vars
  left_tabline = {}
  left_width = 0
  right_tabline = {}
  right_width = 0

  -- left
  tab_markers()

  -- right
  filetype()
  diagnostics()

  -- put together and with padding
  local lhs = table.concat(left_tabline)
  local rhs = table.concat(right_tabline)
  local width = vim.api.nvim_get_option("columns")
  local padding = width - (left_width + right_width)
  return lhs .. string.rep(" ", padding) .. rhs
end

function M.setup()
  util.create_autogroups({
    tabline_highlights = {
      {"ColorScheme", "*", "lua require('ui.tabline').highlighting()"}
    }
  })

  function _G.my_tabline()
    return tabline()
  end

  vim.o.tabline = "%!v:lua.my_tabline()"
end

function M.highlighting()
  set_highlight("TabLine", {fg(c.blue2), bg(c.shadow)})
  set_highlight("TabLineSel", {fg(c.green1), bg(c.bg)})
  set_highlight("TabLineFill", {fg(c.shadow), bg(c.shadow)})
  set_highlight("TabLineAtomHeader", {fg(c.green1), bg(c.shadow)})
  set_highlight("TabLineDiagError", {fg(c.red1), bg(c.shadow)})
  set_highlight("TabLineDiagWarn", {fg(c.yellow3), bg(c.shadow)})
end

return M
