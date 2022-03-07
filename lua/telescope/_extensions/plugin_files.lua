local function find_files(_)
  return require("telescope/builtin/files").find_files({
    shorten_path = false,
    cwd = "~/.local/share/nvim/site/pack/packer",
    prompt = "NVIM plugins - files",
    hidden = true,
  })
end

local function live_grep(_)
  return require("telescope/builtin/files").live_grep({
    shorten_path = false,
    cwd = "~/.local/share/nvim/site/pack/packer",
    search_dirs = { "~/.local/share/nvim/site/pack/packer" },
    prompt = "NVIM plugins - live grep",
    hidden = true,
  })
end

return require("telescope").register_extension({
  exports = {
    find_files = find_files,
    live_grep = live_grep,
  },
})
