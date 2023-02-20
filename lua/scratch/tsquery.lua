-- can i make a generic capture of a given file, so that can add terminology or person etc
local util = require('vim.lsp.util')
-- TODO of just find any headers, so nested work?
local query_str = [[
(heading1) @head
]]

local buf_nr = 17 -- an norg buffer open
local parser = vim.treesitter.get_parser(buf_nr, "norg")
local tree = parser:parse()[1]
-- vim.pretty_print(parser:parse())
-- vim.pretty_print(tree)
tree:root()

local query = vim.treesitter.parse_query("norg", query_str)
for id, node in query:iter_captures(tree:root(), buf_nr, 0, -1) do
  local capture = query.captures[id]
  local line_nr = node:start()
  local line = vim.treesitter.get_node_text(node, buf_nr, {concat = false})[1]
  if line:find("^%s*%*%sTerminology$") then
    print("found on line: ", line_nr)
    local lines = {"", "{$ TEST}", "Somestuff"}
    vim.api.nvim_buf_set_lines(buf_nr, line_nr+1, line_nr+1, false, lines)
    -- TODO how to format the inserted shit?
    -- local savedic = vim.fn.winsaveview()
    -- vim.cmd(line_nr..","..line_nr+#lines.."normal! ==")
    -- vim.fn.winrestview(savedic)

    -- lifted from https://github.com/neovim/neovim/blob/30ca6d23a9c77175a76a4cd59da81de83d9253af/runtime/lua/vim/lsp.lua
    -- lsp.formatexpr()
    --
    -- whcich is set as formatexpr... but is this not getting used?
    -- wher eis the client coming from, as ust null-ls which shouldm't be doing anything
    local start_lnum = line_nr -1
    local end_lnum = line_nr + 10
    for _, client in pairs(vim.lsp.get_active_clients({ bufnr = buf_nr })) do
      print("Cleint found")
      if client.supports_method('textDocument/rangeFormatting') then
        print("capable")
        local params = util.make_formatting_params()
        local end_line = vim.fn.getline(end_lnum)
        local end_col = util._str_utfindex_enc(end_line, nil, client.offset_encoding)
        params.range = {
          start = {
            line = start_lnum - 1,
            character = 0,
          },
          ['end'] = {
          line = end_lnum - 1,
          character = end_col,
        },
      }
      local response =
      client.request_sync('textDocument/rangeFormatting', params, 500, buf_nr)
      if response.result then
        vim.lsp.util.apply_text_edits(response.result, 0, client.offset_encoding)
        return 0
      end
    end
  end
end
end
