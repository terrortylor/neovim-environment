return {
  desc = "Simply runs checktime to reload files",
  constructor = function(params)
    return {
      on_complete = function(self, task, status, result)
        vim.cmd("checktime")
      end,
    }
  end,
}
