local c = require("config.colours").c
local highlights = require("util.highlights")
local set_highlight = highlights.set_highlight
local fg = highlights.guifg
local bg = highlights.guibg
local lsp_funcs = require("lsp.diagnostics")
local ignore_filetype = require("util.buffer").ignore_filetype

local left_tabline = {}
local left_width = 0
local right_tabline = {}
local right_width = 0

local M = {}
local tab_names = {}
local isRecording = false

local function add_left(hl, text)
  table.insert(left_tabline, "%#" .. hl .. "#")
  left_width = left_width + string.len(text)
  table.insert(left_tabline, text)
end

local function add_right(hl, text)
  table.insert(right_tabline, "%#" .. hl .. "#")
  right_width = right_width + string.len(text)
  table.insert(right_tabline, text)
end

local function show_tab_markers()
  local num_tabs = vim.fn.tabpagenr("$")
  local curent_tab = vim.fn.tabpagenr()

  if num_tabs > 1 then
    for t = 1, num_tabs do
      -- handle if tab is selected, and tab number
      local highlight
      if t == curent_tab then
        highlight = "TabLineSel"
        add_left(highlight, " [" .. t .. "] ")
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

local function current_signature(width)
  local sig = require("lsp_signature").status_line(width)
  if sig.label ~= "" then
    add_right("LspSignatureActiveParameter", " [" .. sig.label .. "] ")
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
  if ignore_filetype() then
    return
  end

  if not skip then
    add_right("TabLineAtomHeader", " FT: ")
    add_right("TabLine", filetype)
  end
end

local function recording()
  if not isRecording then
    return
  end
  local rec = vim.fn.reg_recording()
  if rec == "" then
    return
  end
  add_right("TabLineAtomHeader", " Rec: ")
  add_right("TabLine", rec)
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
  -- current_signature(80)
  recording()
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

local function highlighting()
  -- TODO this is same as current line marker, and looks a bit shit, better backgroud colour required
  set_highlight("TabLine", { fg(c.blue2), bg(c.purple) })
  set_highlight("TabLineSel", { fg(c.green1), bg(c.purple) })
  set_highlight("TabLineFill", { fg(c.shadow), bg(c.purple) })
  set_highlight("TabLineAtomHeader", { fg(c.green1), bg(c.purple) })
  set_highlight("TabLineAutoUpdate", { fg(c.green1), bg(c.purple) })
  set_highlight("TabLineDiagError", { fg(c.red1), bg(c.purple) })
  set_highlight("TabLineDiagWarn", { fg(c.yellow3), bg(c.purple) })
end

function M.setup()
  local tabline = "%!luaeval('require(\"ui.tabline\").tabline()')"
  local group = vim.api.nvim_create_augroup("tabline_group", { clear = true })
  vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
      highlighting()
    end,
    group = group,
  })
  vim.api.nvim_create_autocmd("RecordingEnter", {
    pattern = "*",
    callback = function()
      isRecording = true
      vim.cmd("redrawtabline")
    end,
    group = group,
  })
  vim.api.nvim_create_autocmd("RecordingLeave", {
    pattern = "*",
    callback = function()
      isRecording = false
      vim.cmd("redrawtabline")
    end,
    group = group,
  })
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

  vim.o.tabline = tabline

  -- TODO set up as user_command
  local command = {
    "command!",
    "-nargs=0",
    "TabSetName",
    "lua require('ui.tabline').set_tab_name()",
  }
  vim.cmd(table.concat(command, " "))
end

function M.set_tab_name()
  local name = nil
  vim.ui.input({ prompt = "Tab name: "},
  function(input)
    name =  input
  end
  )
  tab_names[vim.fn.tabpagenr()] = name
  vim.cmd("redrawtabline")
end

return M
