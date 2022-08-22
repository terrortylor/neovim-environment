local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local packer_bootstrap = false
if fn.empty(fn.glob(install_path)) > 0 then
  print("Init packer.nvim")
  packer_bootstrap = true
  fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })

  vim.api.nvim_command("packadd packer.nvim")
end

local disabled_built_ins = {
  "netrw",
  "netrwPlugin",
  "netrwSettings",
  "netrwFileHandlers",
  "gzip",
  "zip",
  "zipPlugin",
  "tar",
  "tarPlugin",
  "getscript",
  "getscriptPlugin",
  "vimball",
  "vimballPlugin",
  "2html_plugin",
  "logipat",
  "rrhelper",
  "spellfile_plugin",
  "matchit",
}

for _, plugin in pairs(disabled_built_ins) do
  vim.g["loaded_" .. plugin] = 1
end

return require("packer").startup(function(use)
  use({
    "wbthomason/packer.nvim",
    config = function()
      vim.api.nvim_create_autocmd("bufenter", {
        pattern = "lua/config/plugins.lua",
        callback = function()
          -- luacheck: ignore
          vim.api.nvim_buf_set_keymap(
            0,
            "n",
            "<leader>nn",
            "<cmd>wall<cr> | <cmd>luafile %<cr> | <cmd>PackerSync<cr>",
            {}
          )
        end,
        group = vim.api.nvim_create_augroup("packer-config-mapping", { clear = true }),
      })
    end,
  })

  -- use({
  --   "~/personal-workspace/nvim-plugins/nvim-httpclient",
  --   config = function()
  --     require("nvim-httpclient").setup()
  --   end,
  -- })

  -- colour scheme
  -- Setting the colourscheme here prevents the info screen showing when opened without a file
  use({
    "folke/tokyonight.nvim",
    config = function()
      vim.cmd("colorscheme tokyonight")
    end,
  })

  -- toggle comments
  use({
    -- "terrortylor/nvim-comment",
    "~/personal-workspace/nvim-plugins/nvim-comment",
    config = function()
      require("nvim_comment").setup({
        comment_empty = false,
      })
    end,
  })

  -- optimisation
  use({
    "lewis6991/impatient.nvim",
  })

  -- navigation
  use({
    {
      -- tmux/vim magic!
      "christoomey/vim-tmux-navigator",
      config = function()
        -- vim.g.tmux_navigator_no_mappings = 1
        vim.g.tmux_navigator_disable_when_zoomed = 1
        vim.g.tmux_navigator_save_on_switch = 2
      end,
    },
    -- quickly jump to locations in the visible buffer
    {
      "~/personal-workspace/nvim-plugins/hop.nvim",
      -- "phaazon/hop.nvim",
      -- Not really sure this made much of a difference
      -- keys = {
      --   "<leader>fj",
      --   "<leader>jj",
      --   "<leader>/",
      --   "<leader>jf",
      -- },
      config = function()
        require("plugins.hop")
      end,
    },
    {
      "kyazdani42/nvim-tree.lua",
      -- norg rename file for updating links
      -- ft = { "norg" },
      -- cmd = {
      --   "nvimtreefindfile",
      --   "NvimTreeFindFileToggle",
      --   "NvimTreeFocus",
      --   "NvimTreeOpen",
      --   "NvimTreeToggle",
      -- },
      -- keys = { "<c-n>" },
      config = function()
        require("plugins.nvim-tree").setup()
      end,
    },
    -- {
    -- 	"takac/vim-hardtime",
    -- 	config = function()
    -- 		vim.g.hardtime_default_on = 1
    -- 		vim.g.hardtime_showmsg = 1
    -- 		vim.g.hardtime_maxcount = 3
    -- 		vim.g.hardtime_ignore_quickfix = 1
    -- 		vim.g.hardtime_allow_different_key = 1
    -- 		vim.g.hardtime_ignore_buffer_patterns = { "org", "markdown" }
    -- 		vim.g.list_of_normal_keys = { "h", "j", "k", "l", "-", "+", "<LEFT>", "<RIGHT>" }
    -- 	end,
    -- },
  })

  -- session management
  use({
    "rmagatti/auto-session",
    config = function()
      require("auto-session").setup({ auto_restore_enabled = false })
    end,
  })

  -- neovim general library, dependancy for many plugins, also a neovim lua test runner :)
  -- nvim-terminal provides colour code conceal for nicer output
  use({
    -- "nvim-lua/plenary.nvim",
    "norcalli/nvim-terminal.lua",
    ft = "terminal",
    config = function()
      require("terminal").setup()
    end,
  })

  use({
    "nvim-neorg/neorg",
    config = function()
      require("plugins.neorg")
    end,
    -- requires = {"nvim-lua/plenary.nvim", "nvim-neorg/neorg-telescope"}
    requires = { "nvim-lua/plenary.nvim", "~/personal-workspace/nvim-plugins/neorg-telescope" },
  })

  -- general editing
  use({
    -- autopairs
    {
      "windwp/nvim-autopairs",
      config = function()
        require("nvim-autopairs").setup({
          disable_filetype = { "TelescopePrompt", "vim" },
        })
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        local cmp = require("cmp")
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))
      end,
      requires = { "hrsh7th/nvim-cmp" },
    },
    -- surround manipulation
    {
      "kylechui/nvim-surround",
      config = function()
        require("plugins.nvim-surround")
      end,
    },
    {
      -- make search replace varients better
      "tpope/vim-abolish",
      config = function()
        vim.g.abolish_no_mappings = true
      end,
    },
  })

  -- telescope
  use({
    {
      "nvim-lua/plenary.nvim",
    },
    {
      "nvim-telescope/telescope.nvim",
      requires = {
        "nvim-lua/popup.nvim",
        "nvim-lua/plenary.nvim",
      },
      config = function()
        require("plugins.telescope").setup()
      end,
    },
    {
      "nvim-telescope/telescope-ui-select.nvim",
      requires = {
        "nvim-telescope/telescope.nvim",
      },
    },
    {
      -- adds github pull integration into telescope
      "nvim-telescope/telescope-github.nvim",
      config = function()
        require("telescope").load_extension("gh")
      end,
      requires = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
      },
    },
  })

  -- treesitter
  -- TODO tryout: https://github.com/mizlan/iswap.nvim
  use({
    {
      "nvim-treesitter/nvim-treesitter",
      run = ":TSUpdate",
      config = function()
        -- requred for neorg
        local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()

        parser_configs.norg_meta = {
          install_info = {
            url = "https://github.com/nvim-neorg/tree-sitter-norg-meta",
            files = { "src/parser.c" },
            branch = "main",
          },
        }

        parser_configs.norg_table = {
          install_info = {
            url = "https://github.com/nvim-neorg/tree-sitter-norg-table",
            files = { "src/parser.c" },
            branch = "main",
          },
        }

        require("nvim-treesitter.configs").setup({
          ensure_installed = {
            "javascript",
            "yaml",
            "markdown",
            "typescript",
            "lua",
            "go",
            "norg",
            "norg_meta",
            "norg_table",
          },
          highlight = {
            enable = true,
          },
          query_linter = {
            enable = true,
            use_virtual_text = true,
            lint_events = { "BufWrite", "CursorHold" },
          },
        })
      end,
    },
    {
      "nvim-treesitter/playground",
      opt = true,
      cmd = { "TSPlaygroundToggle" },
      requires = { "nvim-treesitter/nvim-treesitter" },
    },
    {
      "RRethy/nvim-treesitter-textsubjects",
      requires = { "nvim-treesitter/nvim-treesitter" },
      config = function()
        require("nvim-treesitter.configs").setup({
          textsubjects = {
            enable = true,
            keymaps = {
              ["."] = "textsubjects-smart",
              [";"] = "textsubjects-container-outer",
            },
          },
        })
      end,
    },
  })

  -- snippets
  use({
    "L3MON4D3/LuaSnip",
    config = function()
      require("plugins.luasnip").setup()
    end,
  })

  -- GIT
  use({ -- git signs
    {
      "lewis6991/gitsigns.nvim",
      config = function()
        require("plugins.gitsigns").setup()
      end,
    },
    {
      "rhysd/conflict-marker.vim",
      config = function()
        vim.g.conflict_marker_highlightgroup = ""
        vim.cmd([[
          highlight ConflictMarkerBegin guibg=#2f7366
          highlight ConflictMarkerOurs guibg=#2e5049
          highlight ConflictMarkerTheirs guibg=#344f69
          highlight ConflictMarkerEnd guibg=#2f628e
          highlight ConflictMarkerCommonAncestorsHunk guibg=#754a81
        ]])

        local md = vim.api.nvim_create_augroup("conflict-marker-remindme", { clear = true })
        vim.api.nvim_create_autocmd("VimEnter", {
          once = true,
          pattern = "*",
          callback = function()
            local detected = vim.api.nvim_eval("conflict_marker#detect#markers()")
            if detected ~= 0 then
              local win = require("pa").remindme({ args = "conflict-marker" })
              if vim.api.nvim_win_is_valid(win) then
                vim.api.nvim_set_current_win(win)
              end
            end
          end,
          group = md,
        })
      end,
    },
  })

  use({
    "github/copilot.vim",
    cmd = { "Copilot" },
    config = function()
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true
      vim.g.copilot_tab_fallback = ""

      function _G.copilot_keymap()
        local copilot_keys = vim.fn["copilot#Accept"]()
        if copilot_keys ~= "" and type(copilot_keys) == "string" then
          vim.api.nvim_feedkeys(copilot_keys, "i", true)
        end
      end

      -- terrible mapping choice, TODO change this
      vim.api.nvim_set_keymap("i", "<C-a>", "<cmd>lua _G.copilot_keymap()<cr>", { noremap = true, silent = true })
    end,
  })

  -- language server
  use({
    {
      "neovim/nvim-lspconfig",
      config = function()
        require("plugins.lsp.sumneko")
        require("plugins.lsp.tsserver")
        require("plugins.lsp.terraform")
        -- not required when using ray-s/go.nvim
        require("plugins.lsp.gopls")
        require("plugins.lsp.efm")
        require("plugins.lsp.null-ls")
      end,
      requires = {
        "jose-elias-alvarez/null-ls.nvim",
        "nvim-lua/plenary.nvim",
      },
    },
    {
      -- This config is called when attaching a lsp
      "ray-x/lsp_signature.nvim",
    },
    {
      -- show lightbulb when code action
      "kosayoda/nvim-lightbulb",
      opt = true,
      -- this is loaded when on attach is called
    },
  })

  -- debugging (DAP)
  use({
    {
      "mfussenegger/nvim-dap",
      config = function()
        require("plugins.nvimdap")
      end,
      requires = {
        "rcarriga/nvim-dap-ui",
        "theHamsta/nvim-dap-virtual-text",
        "nvim-treesitter/nvim-treesitter",
      },
    },
    {
      "nvim-telescope/telescope-dap.nvim",
      config = function()
        require("telescope").load_extension("dap")
      end,
      requires = {
        "nvim-neorg/neorg-telescope",
        "mfussenegger/nvim-dap",
        "nvim-treesitter/nvim-treesitter",
      },
    },
    -- languages:
    -- GO
    {
      "leoluz/nvim-dap-go",
      config = function()
        require("dap-go").setup()
      end,
    },
    -- lua (nvim)
    {
      "folke/lua-dev.nvim",
    },
  })

  -- completion
  use({
    "hrsh7th/nvim-cmp",
    config = function()
      require("plugins.nvim-cmp").setup()
    end,

    requires = {
      "L3MON4D3/LuaSnip",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-document-symbol",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      -- "andersevenrud/cmp-tmux",
      "~/personal-workspace/nvim-plugins/cmp-tmux",
      "f3fora/cmp-spell",
      "hrsh7th/cmp-nvim-lua",
      -- "hrsh7th/cmp-nvim-lsp-signature-help"
    },
  })

  use({
    "ThePrimeagen/refactoring.nvim",
    config = function()
      require("plugins.refactor").setup()
    end,
    requires = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-treesitter/nvim-treesitter" },
    },
  })

  -- Language Specific
  use({
    "aliou/bats.vim",
    ft = { "bats" },
  })
  -- GO
  use({
    {
      "ray-x/go.nvim",
      requires = { "nvim-telescope/telescope.nvim" },
      ft = { "go" },
      config = function()
        require("plugins.go-nvim").setup()
      end,
    },
    -- Terraform
    {
      "hashivim/vim-terraform",
      ft = { "terraform" },
    },
  })

  -- testing
  use({
    "vim-test/vim-test",
    ft = { "javascript", "typescript", "go" },
    config = function()
      require("plugins.vim-test").setup()
    end,
  })

  if packer_bootstrap then
    require("packer").sync()
  end
end)
