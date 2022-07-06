vim.opt.spell = true
vim.opt.spelllang = { 'en_gb' }
-- vim.o.conceallevel = 2
-- vim.o.concealcursor = "nc"

local set = vim.keymap.set
set("i", "<C-b>", "*", {buffer = true})
set("n", "<leader>ff", ":Telescope neorg find_linkable<CR>", {buffer = true})

-- Dirty but works, hooks into nvim-tree rename so when a file is renamed in NORG
-- use grep to find alllink refferences, and then sed to update each one.
local function update_links_to_file(data)
  local job = require("plenary.job")

  local getFileContainingString = function(filePath, path)
    local results = {}
    local grepJob = job:new {
      command = "grep",
      args = {"-rl", ":$" .. filePath .. ":", path},
      on_stdout = function(_, line)
        table.insert(results, line)
      end,
    }
    grepJob:sync()
    return results
  end

  local update_with_sed = function(results, old, new)
    for _,f in pairs(results) do
      -- print("F: " .. f)
      local sub = "s#:$" .. old .. ":#:$" .. new .. ":#g"
      -- print("sub: " .. sub)
      local sedJob = job:new {
        command = "sed",
        args = {"-i", sub, f},
      }
      sedJob:sync()
    end
  end

  local cur_path = require("neorg/modules/core/norg/dirman/module").public.get_current_workspace()[2]
  local cur_old_name = data.old_name:gsub(vim.pesc(cur_path), ""):gsub(".norg", "")
  local cur_new_name = data.new_name:gsub(vim.pesc(cur_path), ""):gsub(".norg", "")
  local grepResults = getFileContainingString(cur_old_name, cur_path)


  -- print(vim.pretty_print(results))
  update_with_sed(grepResults, cur_old_name, cur_new_name)
  local unModifiedFiles = getFileContainingString(cur_old_name, cur_path)
  -- TODO doesn't seem to refresh current buffer open
  vim.cmd(":checktime")
  if vim.tbl_count(unModifiedFiles) > 0 then
    print("Some backlinks have not been modified! Expected: " .. vim.tbl_count(grepResults) .. " but have " .. vim.tbl_count(unModifiedFiles) .. " unmodified files.")
  else
    print("Updated " .. vim.tbl_count(grepResults) .. " files with backlinks")
  end
end

local events = require('nvim-tree.events')
if vim.g.neorg_rename_event == nil then
  events.on_node_renamed(update_links_to_file)
  vim.g.neorg_rename_event = 1
end
-- update_links_to_file({old_name = "/tech/azure/static-web-app", new_name = "goat"})

