local api = vim.api
local util = require("util.config")
local path_elements = require("util.path").path_elements

local M = {}

M.opts = {
  wikis = {
    main = "~/personnal-workspace/notes"
  },
  -- TODO doesn't take into account vim's iskeyword value
  link_pattern = "%[%[(%S*)%]%]",
  extension = ".md",
}

-- TODO can be local
function M.is_word_link(link_pattern, word)
 if word:find(link_pattern) then
   return true
 end
 return false
end

-- TODO can be local
function M.get_link_text(link_pattern, word)
  local link = word:match(link_pattern)

  -- if ends in slash then look for link/index.md
  -- TODO would maybe like a way on not having the slash here?
  if link:find(".+/$") then
    link = link .. "index"
  end

  return link
end

-- TODO filesystem funcs here can be split out
--- Get current buf path, add link to end check exists
-- if not then remove directory form buf path, and add link to end check exists... all
-- the way up to / or ideally root of proect i.e. .git dir
local function work_out_link_path(link, extension)
  -- This should be passed as parameter
--  local cwd = api.nvim_call_function("getcwd", {})
  local cwd = api.nvim_call_function("expand", {"%:p:h"})

  local link_path
  local exists

  for _,i in path_elements(cwd) do
    link_path = i .. "/" .. link .. extension
    exists = api.nvim_call_function("filereadable", {link_path})

    exists = exists > 0
    if exists then
      break
    end
  end

  if not exists then
    return exists, cwd .. "/" .. link .. extension
  end

  return exists, link_path
end
-- END TODO

-- TODO add tests
function M.is_wiki_file(paths)
  -- TODO this should be passed in to func
  local file_path = api.nvim_call_function("expand", {"%:p:h"})

  for _,v in pairs(paths) do
    local wiki_path = api.nvim_call_function("expand", {v})
    if file_path:find(vim.pesc(wiki_path)) then
      return true
    end
  end

  return false
end

-- TODO add tests
function M.set_filetype_if_path_matches()
  if M.is_wiki_file(M.opts.wikis) then
    -- TODO set this to just wiki and import markdown in ultisnips somehow?
    api.nvim_buf_set_option(0, "filetype", "wiki.markdown")
  end
end

-- TODO add tests
function M.follow_link()
  local cword = api.nvim_call_function("expand", {"<cWORD>"})
  if not M.is_word_link(M.opts.link_pattern, cword) then
    return
  end

  local link = M.get_link_text(M.opts.link_pattern, cword)
  local exists, path = work_out_link_path(link, M.opts.extension)
  print(exists, path)

  if not exists then
    local dir = api.nvim_call_function("fnamemodify", {path, ":p:h"})
    local dir_exists = api.nvim_call_function("isdirectory", {dir})

    if dir_exists == 0 then
      local create = api.nvim_call_function("confirm",
        {"Directory path doesn't exist, would you like to create: " .. dir, "&Yes\n&No", 2})
      if create > 1 then
        return
      end
    end

    os.execute("mkdir -p " .. dir)
  end

  api.nvim_command("edit " .. path)
end

function M.setup()
  -- Create filetype detect autocommand
  local autogroups = {
    wiki_set_filetype = {
      {"BufRead,BufNewFile", "*.md", "lua require('wiki').set_filetype_if_path_matches()"}
    }
  }

  util.create_autogroups(autogroups)

end

return M
