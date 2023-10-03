local M = {}

-- this is soley for abstracting neorg dependency in testing
function M.getNeorgCurrentWorkspaceDir()
  return require("neorg.modules.core.dirman.module").public.get_current_workspace()[2]
end

-- Dirty but works, hooks into nvim-tree rename so when a file is renamed in NORG
-- use grep to find alllink refferences, and then sed to update each one.
function M.update_links_to_file(data)
  local job = require("plenary.job")

  local getFileContainingString = function(filePath, path)
    local results = {}
    local grepJob = job:new({
      command = "grep",
      args = { "-rl", ":$" .. filePath .. ":", path },
      on_stdout = function(_, line)
        table.insert(results, line)
      end,
    })
    grepJob:sync()
    return results
  end

  local update_with_sed = function(results, old, new)
    for _, f in pairs(results) do
      -- print("F: " .. f)
      local sub = "s#:$" .. old .. ":#:$" .. new .. ":#g"
      -- print("sub: " .. sub)
      local sedJob = job:new({
        command = "sed",
        args = { "-i", sub, f },
      })
      sedJob:sync()
    end
  end

  local cur_path = M.getNeorgCurrentWorkspaceDir()
  -- strip neorg workspace path to get relative link path
  -- strip off .norg file extension also
  local cur_old_name = data.old_name:gsub(vim.pesc(cur_path), ""):gsub(".norg", "")
  local cur_new_name = data.new_name:gsub(vim.pesc(cur_path), ""):gsub(".norg", "")
  local grepResults = getFileContainingString(cur_old_name, cur_path)

  -- print(vim.pretty_print(results))
  update_with_sed(grepResults, cur_old_name, cur_new_name)
  local unModifiedFiles = getFileContainingString(cur_old_name, cur_path)

  -- reload buffers modified exernally
  vim.cmd(":checktime")
  if vim.tbl_count(unModifiedFiles) > 0 then
    local message = "Some backlinks have not been modified! Expected: " .. vim.tbl_count(grepResults)
    message = message .. " but have " .. vim.tbl_count(unModifiedFiles)
    message = message .. " unmodified files."
    print(message)
  else
    print("Updated " .. vim.tbl_count(grepResults) .. " files with backlinks")
  end
end

-- add hook to nvim-tree rename event
-- should only be added once
function M.nvimTreeRenameEventHook()
  local Event = require("nvim-tree.api").events.Event
  local api = require("nvim-tree.api")
  api.events.subscribe(Event.NodeRenamed, M.update_links_to_file)
end

return M
