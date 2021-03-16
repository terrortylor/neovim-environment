require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 2;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    ultisnips = {
      priority = 2000
    };
    nvim_lsp = true;
    buffer = true;
    path = true;
    nvim_lua = {
      priority = 1100,
      filetypes = {"lua"}
    };
    spell = true;
    tags = true;
  };
}
