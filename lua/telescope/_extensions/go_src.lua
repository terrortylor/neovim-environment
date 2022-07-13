local function find_files_go_src(_)
  return require("telescope/builtin/__files").find_files({
    shorten_path = false,
    cwd = "/usr/local/go/src",
    prompt = "Go Src files",
    hidden = false,
  })
end

local function find_files_pkg_src(_)
  return require("telescope/builtin/__files").find_files({
    shorten_path = false,
    cwd = "~/go/pkg/src",
    prompt = "Go pkg Src files",
    hidden = false,
  })
end

local function live_grep_go_src(_)
  return require("telescope/builtin/__files").live_grep({
    shorten_path = false,
    cwd = "/usr/local/go/src",
    search_dirs = { "/usr/local/go/src" },
    prompt = "Go core live grep",
    hidden = false,
  })
end

local function live_grep_pkg_src(_)
  return require("telescope/builtin/__files").live_grep({
    shorten_path = false,
    cwd = "~/go/src",
    search_dirs = { "~/go/pkg/mod" },
    prompt = "Go pkg src live grep",
    hidden = false,
  })
end

return require("telescope").register_extension({
  exports = {
    find_files_go_src = find_files_go_src,
    find_files_pkg_src = find_files_pkg_src,
    live_grep_go_src = live_grep_go_src,
    live_grep_pkg_src = live_grep_pkg_src,
  },
})
