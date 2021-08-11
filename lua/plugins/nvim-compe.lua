local M = {}

function M.setup()
  vim.o.completeopt = "menuone,noselect"

  require'compe'.setup {
    enabled = true;
    autocomplete = true;
    debug = false;
    min_length = 2;
    preselect = 'always';
    throttle_time = 80;
    source_timeout = 200;
    incomplete_delay = 400;
    max_abbr_width = 100;
    max_kind_width = 100;
    max_menu_width = 100;
    documentation = {
      border = { '┌', '─', '┐', '│', '┘', '─', '└', '│',},
      winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
      max_width = 120,
      min_width = 60,
      max_height = math.floor(vim.o.lines * 0.5),
      min_height = 5,
    };

    source = {
      ultisnips = {
        priority = 2000
      };
      nvim_lsp = {
        priority = 1400,
        filetypes = {"javascript", "typescript", "lua", "go"}
      };
      buffer = {
        priority = 1300,
        ignored_filetypes = {"javascript", "typescript", "go"}
      };
      nvim_lua = {
        priority = 1100,
        filetypes = {"lua"}
      };
      path = {
        priority = 1000,
      };
      spell = true;
      tags = true;
    };
  }

  -- if lexima loaded then setup correct mappings
  -- lexima must be loaded before compe!
  local crMap = "compe#confirm('<CR>')"
  if  vim.g.loaded_lexima == 1 then
    vim.g.lexima_no_default_rules = true
    vim.cmd("call lexima#set_default_rules()")
    crMap = "compe#confirm(lexima#expand('<LT>CR>', 'i'))"
  end

  require('util.config').create_mappings({
    i = {
      ["<C-Space>"] = {"compe#complete()", {silent = true, expr = true}},
      ["<CR>"]      = {crMap, {silent = true, expr = true}},
      ["<C-e>"]     = {"compe#close('<C-e>')", {silent = true, expr = true}},
    },
  })

end

return M
