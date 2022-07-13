local function find_files(_)
  return require("telescope/builtin/__files").find_files({
    shorten_path = false,
    cwd = "~/.bashrc.d/",
    prompt = "bashrc.d files",
    hidden = true,
  })
end

local function live_grep(_)
  return require("telescope/builtin/__files").live_grep({
    shorten_path = false,
    cwd = "~/.bashrc.d/",
    search_dirs = { "~/.bashrc.d/" },
    prompt = "bashrc.d files",
    hidden = true,
  })
end

return require("telescope").register_extension({
  exports = {
    find_files = find_files,
    live_grep = live_grep,
  },
})
