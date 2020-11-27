local api = vim.api

local M = {}

M.default_pattern = "function"

M.filetype_func_pattern = {
  lua = "^(local\\s)?function|\\s*?\\d+\\s*?=function",
  markdown = "^#",
  ["wiki.markdown"] = "^#",
}

local function shell_escape(input)
  return api.nvim_call_function("shellescape", {input})
end

--- Wrapper function for running RipGrep in fzf lifted from the fzf.vim Readme docs.
-- This interactively runs ripgrep, so rust regex query and not actual fzf finding. (see phony flag)
-- @param path string path to start search from, can be empty in which case from current location
-- @param query string can be empty
-- @param run_fullscreen string in not nil then runs fzf in run_fullscreen
function M.ripgrep_phony(path, query, fullscreen)
  local run_fullscreen = 0
  if fullscreen ~= "" then run_fullscreen = 1 end

  local command_fmt = "rg --column --line-number --no-heading --color=always --smart-case -- %s %s || true"
  local initial_command = string.format(command_fmt, shell_escape(query), path)
  local reload_command = string.format(command_fmt, "{q}", path)
  local spec = {options = {"--phony", "--query", query, "--bind", "change:reload:"..reload_command}}
  local with_preview = api.nvim_call_function("fzf#vim#with_preview", {spec})

  api.nvim_call_function("fzf#vim#grep", {initial_command, 1, with_preview, run_fullscreen})
end

--- Wrapper that calls ripgrep with query, then opens fzf on results
-- TODO need a formatter to use shortened filenames
function M.fzf_ripgrep_results(path, query, fullscreen)
  local run_fullscreen = 0
  if fullscreen ~= "" then run_fullscreen = 1 end

  local command_fmt = "rg --with-filename --column --line-number --no-heading --color=always --smart-case -- %s %s"
  local initial_command = string.format(command_fmt, shell_escape(query), path)
  local spec = {options = {}}
  local with_preview = api.nvim_call_function("fzf#vim#with_preview", {spec})

  api.nvim_call_function("fzf#vim#grep", {initial_command, 1, with_preview, run_fullscreen})
end

--- Used to fzf find "functions" in either current bffer only or CWD
-- This is driven by a map that maps a rg regex (rust) to a filetype,
-- so for markdown functions are in fact headers
function M.fzf_functions(current_buf_only)
  local rg_path
  if current_buf_only == "" then
    rg_path = api.nvim_call_function("expand", {"%"})
  else
    rg_path = api.nvim_call_function("getcwd", {})
  end

  local query = M.filetype_func_pattern[api.nvim_buf_get_option(0, "filetype")]
  if not query then query = M.default_pattern end

  M.fzf_ripgrep_results(rg_path, query, "")
end

--- Creates a number of helper commands to encapsulate common taks using fzf and riggrep
function M.setup()
  local command = {
    "command!",
    "-nargs=?",
    "-bang",
    "SearchNotes",
    "lua require('fzf').ripgrep_phony('~/personnal-workspace/notes', '<args>', '<bang>')"
  }
  api.nvim_command(table.concat(command, " "))

  local command = {
    "command!",
    "-nargs=0",
    "-bang",
    "Functions",
    "lua require('fzf').fzf_functions('<bang>')"
  }
  api.nvim_command(table.concat(command, " "))
end

return M
