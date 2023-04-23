local M = {}

function M.hint_char1_and_then(and_then_func)
  local hop = require("hop")
  local jump_target = require("hop.jump_target")
  -- return function()
  local opts = hop.opts
  local c = hop.get_input_pattern("Hop 1 char: ", 1)
  local generator = jump_target.jump_targets_by_scanning_lines
  hop.hint_with_callback(generator(jump_target.regex_by_case_searching(c, true, opts)), opts, function(jt)
    hop.move_cursor_to(jt.window, jt.line + 1, jt.column - 1, opts.hint_offset)
    and_then_func()
  end)
  -- end
end

function M.feedkeys_at_remote(action, mode)
  M.hint_char1_and_then(function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(action, true, false, true), mode, true)
  end)
end

function M.hint_lsp_definition()
  M.hint_char1_and_then(function()
    local bf = vim.b.local_hop_definition
    if bf then
      bf()
    else
      if #vim.lsp.buf_get_clients(0) > 0 then
        require("telescope.builtin").lsp_definitions()
      end
    end
  end)
end

function M.hint_lsp_declaration()
  M.hint_char1_and_then(vim.lsp.declaration)
end

function M.hint_lsp_implementations()
  M.hint_char1_and_then(vim.lsp.implementations)
end

function M.hint_lsp_references()
  M.hint_char1_and_then(vim.lsp.references)
end

function M.hint_lsp_type_definition()
  M.hint_char1_and_then(vim.lsp.type_definition)
end


return M
