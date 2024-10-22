return {
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup({
        i = {
          ["j"] = {
            ["j"] = function()
              vim.api.nvim_input("<esc>")
            end,
          },
        },
      })
    end,
  },
}
