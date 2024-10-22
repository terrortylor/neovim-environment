return {
  {
    "gabrielpoca/replacer.nvim",
    opts = { rename_files = false },
    keys = {
      { "<leader>h", ':lua require("replacer").run()<cr>', desc = "quickfix: run replacer.nvim" },
      { "<leader>H", ':lua require("replacer").save()<cr>', desc = "quickfix: save replacer.nvim" },
    },
  },
}
