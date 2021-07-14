local c = require('config.colours').c
local highlights = require('util.highlights')
local set_highlight = highlights.set_highlight
local fg = highlights.guifg
local bg = highlights.guibg
local lsp_funcs = require('config.lsp.funcs')
local util = require('util.config')
local get_user_input = require('util.input').get_user_input

local left_tabline = {}
local left_width = 0
local right_tabline = {}
local right_width = 0

local M = {}
local tab_names = {}

-- TODO this is duplicated in statusline
-- TODO this should not be hard codded?
local ignore_filetypes = {
  "qf",
  "help",
  "TelescopePrompt",
  "NvimTree",
  "lspinfo"
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

local function show_tab_markers()
  local num_tabs = vim.fn.tabpagenr('$')
  local curent_tab = vim.fn.tabpagenr()

  if num_tabs > 1 then
    for t = 1, num_tabs do
      -- handle if tab is selected, and tab number
      local highlight
      if t == curent_tab then

        highlight = "TabLineSel"
        add_left(highlight, " ["..t.."] ")
      else
        highlight = "TabLine"
        add_left(highlight, "  " .. t .. "  ")
      end

      local tab_name = tab_names[t]
      if tab_name then
        add_left(highlight, tab_name)
      else
        -- TODO if active window filetype is in the ignore_filetypes then look for the next available window

        -- show active window buf name
        local tabwinnr = vim.fn.tabpagewinnr(t)
        local tab_bufs = vim.fn.tabpagebuflist(t)
        -- add_left(highlight, vim.fn.pathshorten(vim.fn.bufname(tab_bufs[tabwinnr])))
        -- Show just the filename, not path
        local filename = vim.fn.bufname(tab_bufs[tabwinnr])
        if not filename or filename == "" then
          add_left(highlight, "New File")
        else
          add_left(highlight, filename:match("[^/]*.$"))
        end
      end

      add_left(highlight, " ")
      add_left("TabLineFill", "")
    end
  end
end

local function show_auto_update()
  if not vim.g.enable_auto_update then
    add_right("TabLineAutoUpdate", "[AU - Off] ")
  end
end

local function show_diagnostics()
  if #vim.lsp.buf_get_clients(0) > 0 then
    local total_diagnostics = lsp_funcs.get_all_diagnostic_count()
    add_right("TabLineDiagError", " E: ")
    add_right("TabLine", total_diagnostics.errors)
    add_right("TabLineDiagWarn", " W: ")
    add_right("TabLine", total_diagnostics.warnings)
  end
end

local function show_filetype()
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

function M.tabline()
  -- reset tabline vars
  left_tabline = {}
  left_width = 0
  right_tabline = {}
  right_width = 0

  -- left
  show_tab_markers()

  -- right
  show_auto_update()
  show_filetype()
  show_diagnostics()

  -- put together and with padding
  local lhs = table.concat(left_tabline)
  local rhs = table.concat(right_tabline)
  local width = vim.api.nvim_get_option("columns")
  local padding = width - (left_width + right_width)
  return lhs .. string.rep(" ", padding) .. rhs
end

function M.setup()
  local tabline = "%!luaeval('require(\"ui.tabline\").tabline()')"
  util.create_autogroups({
    tabline_highlights = {
      {"ColorScheme", "*", "lua require('ui.tabline').highlighting()"}
    },
    -- TODO whis breaks but is required as telescope fucks clears tabline
    -- set_tabline = {
      -- {"BufNew", "*", "set tabline=" .. tabline .. ""},
    --   {"BufEnter", "*", tabline},
    --   {"BufWipeout", "*", tabline},
    --   {"BufWinEnter", "*", tabline},
    --   {"BufWinLeave", "*", tabline},
    --   {"BufWritePost", "*", tabline},
    --   {"SessionLoadPost", "*", tabline},
    --   {"OptionSet", "*", tabline},
    --   {"VimResized", "*", tabline},
    --   {"WinEnter", "*", tabline},
    --   {"WinLeave", "*", tabline}
    -- }
  })

  vim.o.tabline = tabline

  local command = {
    "command!",
    "-nargs=0",
    "TabSetName",
    "lua require('ui.tabline').set_tab_name()"
  }
  vim.cmd(table.concat(command, " "))
end

function M.set_tab_name()
  local name = get_user_input("Tabname: ", "")
  tab_names[vim.fn.tabpagenr()] = name
  vim.cmd("redrawtabline")
end

function M.highlighting()
  -- TODO this is same as current line marker, and looks a bit shit, better backgroud colour required
  set_highlight("TabLine", {fg(c.blue2), bg(c.purple)})
  set_highlight("TabLineSel", {fg(c.green1), bg(c.purple)})
  set_highlight("TabLineFill", {fg(c.shadow), bg(c.purple)})
  set_highlight("TabLineAtomHeader", {fg(c.green1), bg(c.purple)})
  set_highlight("TabLineAutoUpdate", {fg(c.green1), bg(c.purple)})
  set_highlight("TabLineDiagError", {fg(c.red1), bg(c.purple)})
  set_highlight("TabLineDiagWarn", {fg(c.yellow3), bg(c.purple)})
end

return M
