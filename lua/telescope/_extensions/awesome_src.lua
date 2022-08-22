local function find_files_awesome_src(_)
  return require("telescope/builtin/__files").find_files({
    shorten_path = false,
    cwd = "/usr/share/awesome/lib",
    prompt = "Awesome lib files",
    hidden = false,
  })
end

local function live_grep_awesome_src(_)
  return require("telescope/builtin/__files").live_grep({
    shorten_path = false,
    cwd = "/usr/share/awesome/lib",
    search_dirs = { "/usr/share/awesome/lib" },
    prompt = "Awesome lib live grep",
    hidden = false,
  })
end

return require("telescope").register_extension({
  exports = {
    find_files_awesome_src = find_files_awesome_src,
    live_grep_awesome_src = live_grep_awesome_src,
  },
})
