local function find_files(_)
  return require("telescope/builtin/files").find_files({
    shorten_path = false,
    cwd = "~/personnal-workspace/notes",
    prompt = "Notes",
    hidden = false,
  })
end

local function live_grep(_)
  return require("telescope/builtin/files").live_grep({
    shorten_path = false,
    cwd = "~/personnal-workspace/notes",
    search_dirs = { "~/personnal-workspace/notes" },
    prompt = "Notes",
    hidden = false,
  })
end

return require("telescope").register_extension({
  exports = {
    find_files = find_files,
    live_grep = live_grep,
  },
})
