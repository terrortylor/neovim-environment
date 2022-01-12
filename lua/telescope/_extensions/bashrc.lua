local function find_files(opts)
  return require("telescope/builtin/files").find_files {
    shorten_path = false,
    cwd = "~/.bashrc.d/",
    prompt = "bashrc.d files",
    hidden = true,
  }
end

local function live_grep(opts)
  return require("telescope/builtin/files").live_grep {
    shorten_path = false,
    search_dirs = {"~/.bashrc.d/"},
    prompt = "bashrc.d files",
    hidden = true,
  }
end

return require("telescope").register_extension({
  exports = {
    find_files = find_files,
    live_grep = live_grep,
  },
})

