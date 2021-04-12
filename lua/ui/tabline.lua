local c = require('config.colours').c
local hl = require('util.highlights')
local set_highlight = hl.set_highlight
local fg = hl.guifg
local bg = hl.guibg
local lsp_funcs = require('config.lsp.funcs')

  local left_tabline = {}
  local left_width = 0
  local right_tabline = {}
  local right_width = 0

local M = {}

local function setup_highlights()
  set_highlight("TabLine", {fg(c.yellow1), bg(c.grey3)})
  set_highlight("TabLineSel", {fg(c.yellow1), bg(c.gb)})
  set_highlight("TabLineFill", {fg(c.shadow), bg(c.shadow)})
  -- set_highlight("TabLineDiagError", {fg(c.red1), bg(c.shadow)})
  -- set_highlight("TabLineDiagWarn", {fg(c.blue4), bg(c.shadow)})
end
   
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
  -- TODO only show if lsp active
  local total_diagnostics = lsp_funcs.get_all_diagnostic_count()
  add_right("LspDiagnosticsSignError", " E: " .. total_diagnostics.errors)
  add_right("LspDiagnosticsSignWarning", " W: " .. total_diagnostics.warnings)
end

local function filetype()
  local filetype = vim.api.nvim_buf_get_option(0, "filetype")
  add_right("TabLineSel", "[" .. string.upper(filetype) .. "]")
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
  setup_highlights()

  function _G.my_tabline()
    return tabline()
  end

  vim.o.tabline = "%!v:lua.my_tabline()"
end

return M
