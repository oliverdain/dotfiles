-- These are keymaps and user commands that become active only when we're in a debugging session. See the autocmd stuff
-- in the config for vimspector below.
local function setup_debug_keys()
   vim.keymap.set("n", "n", "<Plug>VimspectorStepOver")
   vim.keymap.set("n", "s", "<Plug>VimspectorStepInto")
   vim.keymap.set("n", "o", "<Plug>VimspectorStepOut")
   vim.keymap.set("n", "c", "<Plug>VimspectorContinue")
   vim.keymap.set("n", "r", "<Plug>VimspectorRestart")
   vim.keymap.set("n", "b", "<Plug>VimspectorToggleBreakpoint")
   vim.keymap.set("n", "p", "<Plug>VimspectorPause")
   vim.api.nvim_create_user_command("DebugStop", function()
      vim.fn["vimspector#Reset"]()
   end, {})
end

-- Unsets the keymaps and commands setup in setup_debug_keys so the keys revert to normal when we're done debugging.
local function rm_debug_keys()
   vim.keymap.del("n", "n")
   vim.keymap.del("n", "s")
   vim.keymap.del("n", "o")
   vim.keymap.del("n", "c")
   vim.keymap.del("n", "r")
   vim.keymap.del("n", "b")
   vim.keymap.del("n", "p")
   vim.api.nvim_del_user_command("DebugStop")
end

return {
   {
      "puremourning/vimspector",
      init = function()
         vim.g.vimspector_configurations = {
            Run = {
              adapter = "vscode-go",
              filetypes = { "go" },
              configuration = {
                request = "launch",
                program = "${fileDirname}",
                mode = "debug",
                dlvToolPath = "$HOME/go/bin/dlv"
              }
            },
            ["Run Args"] = {
              adapter = "vscode-go",
              filetypes = { "go" },
              configuration = {
                request = "launch",
                program = "${fileDirname}",
                args = { "*${CommandLineArgs}" },
                mode = "debug",
                dlvToolPath = "$HOME/go/bin/dlv"
              }
            },
            Test = {
              adapter = "vscode-go",
              filetypes = { "go" },
              configuration = {
                request = "launch",
                program = "${fileDirname}",
                mode = "test",
                dlvToolPath = "$HOME/go/bin/dlv"
              }
            }
         }
      end,
      config = function()
         local utils = require("utils")
         utils.run_once("vimspector", function()
            vim.cmd([[:VimspectorInstall delve]])
            vim.cmd([[:VimspectorInstall debugpy]])
         end)
         -- require("vimspector").setup()
         -- Vimspector in vim shows variable values if you hover but neovim doesn't have a hover thing so we let \di
         -- be mapped to a command that'll show the variable value in normal and visual mode.
         vim.cmd([[nmap <Leader>di <Plug>VimspectorBalloonEval]])
         vim.cmd([[xmap <Leader>di <Plug>VimspectorBalloonEval]])

         vim.api.nvim_create_user_command("Break", function()
            vim.fn["vimspector#ToggleBreakpoint"]()
         end, {})
         vim.api.nvim_create_user_command("Debug", function()
            vim.fn["vimspector#Continue"]()
         end, {})
         vim.api.nvim_create_user_command("Breakpoints", function()
            vim.fn["vimspector#ListBreakpoints"]()
         end, {})

         -- Trigger keymaps that are only active when debugging
         vim.api.nvim_create_autocmd("User", {
            pattern = "VimspectorJumpedToFrame",
            callback=setup_debug_keys,
         })
         vim.api.nvim_create_autocmd("User", {
            pattern = "VimspectorDebugEnded",
            callback=rm_debug_keys,
         })
      end,
   },
}
