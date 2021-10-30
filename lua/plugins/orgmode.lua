require("orgmode").setup({
  org_agenda_files = {"~/personnal-workspace/notes/**/*"},
  org_indent_mode = "noindent",
  org_default_notes_file = "~/personnal-workspace/notes/refile.org",
  org_todo_keywords = {"TODO(t)", "PROGRESS(p)", "BLOCKED(b)", "|", "DONE(d)"},
  org_agenda_templates = {
    t = {
      description = "Task",
      template = "* TODO %?\n %u"
    },
    n = {
      description = "Note",
      template = "* %?\n %u\n%a"
    },
    w = {
      description = "Work Log",
      template = "* %?\n %u\n%a\n",
      target = "~/personnal-workspace/notes/work-log.org"
    },
  }
})
