return {
  {
    "nvimdev/indentmini.nvim",
    event = "InsertEnter",
    config = function()
      require("indentmini").setup(
        {
          exclude= {'markdown', 'markdown.note'}
        }
      ) -- use default config
    end,
  },
}
