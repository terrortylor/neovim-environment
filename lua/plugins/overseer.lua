return {
  {
    "stevearc/overseer.nvim",

    keys = {
      {
        "<leader>rr",
        "<cmd>OverseerRestartLast<cr>",
        desc = "OverseerRestartLast - Repeats last command, or prompts for selection of task",
      },
    },
    cmd = {
      "OverseerRun",
      "OverseerRunAndOpen",
      "OverseerInfo",
      "OverseerOpen",
      "OverseerBuild",
      "OverseerClose",
      "OverseerRunCmd",
      "OverseerToggle",
      "OverseerClearCache",
      "OverseerLoadBundle",
      "OverseerSaveBundle",
      "OverseerTaskAction",
      "OverseerQuickAction",
      "OverseerRestartLast",
      "OverseerDeleteBundle",
    },
    -- opts = {},
    config = function()
      local overseer = require("overseer")
      overseer.setup({
        task_list = {
          bindings = {
            ["<C-l>"] = false,
            ["<C-h>"] = false,
            ["<C-k>"] = false,
            ["<C-j>"] = false,
          },
        },
      })

      vim.api.nvim_create_user_command("OverseerRestartLast", function()
        local overseer = require("overseer")
        local tasks = overseer.list_tasks({ recent_first = true })
        if vim.tbl_isempty(tasks) then
          overseer.run_template({}, function(task)
            if task then
              overseer.open({ enter = false, direction = "bottom" })
            end
          end)
        else
          tasks[1]:restart()
          -- print("running: ".. vim.inspect(tasks[1]))
          -- overseer.open({ enter = false, direction = "bottom" })
        end
      end, {})

      overseer.register_template({
        name = "Run Shell Script",
        builder = function()
          local file = vim.fn.expand("%:p")
          cmd = { "sh", file }
          return {
            cmd = cmd,
            -- components = {
            -- --   { "on_output_quickfix", set_diagnostics = true },
            --   -- { "open_output", direction = "vertical", focus = false, on_start = "always" },
            --   { "on_output_write_file", filename = '/tmp/ggg'},
            -- --   "on_result_diagnostics",
            -- --   "default",
            -- },
          }
        end,
        condition = {
          filetype = { "sh", "bash" },
        },
      })

      vim.api.nvim_create_user_command("OverseerRunAndOpen", function()
        overseer.run_template({}, function(task)
          if task then
            overseer.open({ enter = false, direction = "bottom" })
          end
        end)
      end, {})
    end,
  },
}
