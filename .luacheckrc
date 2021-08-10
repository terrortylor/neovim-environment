globals = {"Snake", "Cell", "vim", "_TEST", "LOG_LEVEL"}
exclude_files = {"plugin/packer_compiled.lua"}
read_globals = {
  print = {
    fields = {
      revert = {}
    }
  },
  os = {
    fields = {
      execute = {
        fields = {
          revert = {}
        }
      },
    }
  }
}
