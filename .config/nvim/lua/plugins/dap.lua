return {
   {
      "mfussenegger/nvim-dap",
      init = function()
         vim.api.nvim_create_user_command("Debug", function()
            require('dap').continue()
         end, {})
         vim.api.nvim_create_user_command("Break", function()
            require('dap').toggle_breakpoint()
         end, {})
      end,
   },
   {
      "rcarriga/nvim-dap-ui",
      dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"},
      config = function()
         require("dapui").setup()

         local dap = require("dap")
         local dapui = require("dapui")
         dap.listeners.before.attach.dapui_config = function()
           dapui.open()
         end
         dap.listeners.before.launch.dapui_config = function()
           dapui.open()
         end
         dap.listeners.before.event_terminated.dapui_config = function()
           dapui.close()
         end
         dap.listeners.before.event_exited.dapui_config = function()
           dapui.close()
         end
      end,
   },
   {
      "leoluz/nvim-dap-go",
      dependencies = { "mfussenegger/nvim-dap", "nvim-treesitter/nvim-treesitter"  },
      build = function()
         vim.cmd [[ :TSInstall go ]]
      end,
      config = function()
         -- Remove the default Go configs as mosts of them don't work for a go.mod project.
         local dg = require('dap-go')
         require('dap-go').setup()

         -- If we pass our configuratinos to dapu-go.setup() it *adds* them to the default configurations and most of
         -- those don't work for a go.mod project so it ends up cluttered. Instead, we override the dap go configs here
         -- so we have only our entries.
         local dap = require("dap")
         dap.configurations.go = {
            {
              type = "go",
              name = "Debug test",
              request = "launch",
              mode = "test",
              program = "./${relativeFileDirname}",
            },
            {
              type = "go",
              name = "Debug (Arguments)",
              request = "launch",
              program = "./${relativeFileDirname}/...",
              args = dg.get_arguments,
            },
         }

         vim.api.nvim_create_user_command("DebugTest", function()
            require('dap-go').debug_test()
         end, {})
      end,
   }
}
