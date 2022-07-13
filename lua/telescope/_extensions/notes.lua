local function find_files(_)
  return require("telescope/builtin/__files").find_files({
    shorten_path = false,
    cwd = "~/personal-workspace/notes",
    prompt = "Notes",
    hidden = false,
  })
end

local function live_grep(_)
  return require("telescope/builtin/__files").live_grep({
    shorten_path = false,
    cwd = "~/personal-workspace/notes",
    search_dirs = { "~/personal-workspace/notes" },
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
