return {
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        theme = "material",
        globalstatus = true,
      },
      tabline = {
        lualine_a = { "tabs" },
        lualine_z = {  "overseer" },
        -- lualine_z = { "diagnostics" },
      },
      sections = {
        lualine_a = { "mode" },
        -- lualine_b = { "branch", "dmoiff", "diagnostics" },
        lualine_b = { "branch", "diff" },
        lualine_c = {},
        -- lualine_c = { "filename" },
        lualine_x = { "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      winbar = {
        lualine_a = {{
          'filename',
          path = 1,
          shorting_target = 40,
        }},
      },
      inactive_winbar = {
        lualine_a = {{
          'filename',
          path = 1,
          shorting_target = 40,
        }},
      },
    },
  },
}
