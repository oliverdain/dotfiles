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

local function find_python()
  local python_path = vim.fn.exepath('python3') or vim.fn.exepath('python')
  if python_path == '' then
    return nil
  end
  return python_path
end

-- Search up the file tree from file until we find a directory named src and return the path to that.
local function find_src_dir(file_path)
  local current_dir = vim.fn.fnamemodify(file_path, ':p:h')
  
  while current_dir ~= '/' do
    local src_path = current_dir .. '/src'
    if vim.fn.isdirectory(src_path) == 1 then
      return src_path
    end
    current_dir = vim.fn.fnamemodify(current_dir, ':h')
  end
  
  return nil
end

return {
   {
      "puremourning/vimspector",
      init = function()
         vim.g.vimspector_configurations = {
            ["Go Run"] = {
              adapter = "vscode-go",
              filetypes = { "go" },
              configuration = {
                request = "launch",
                program = "${fileDirname}",
                mode = "debug",
                dlvToolPath = "$HOME/go/bin/dlv"
              }
            },
            ["Go Run Args"] = {
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
            ["Go Test"] = {
              adapter = "vscode-go",
              filetypes = { "go" },
              configuration = {
                request = "launch",
                program = "${fileDirname}",
                mode = "test",
                dlvToolPath = "$HOME/go/bin/dlv"
              }
            },
            ["Py Run"] = {
               adapter = "debugpy",
               configuration = {
                   name = "run the executable",
                   filetypes = { "python" },
                   request = "launch",
                   args = {"*${CommandLineArgs}" },
                   python = find_python(),
                   -- TODO: I couldn't figure out a nice way to automatically generate this from the file name. I think
                   -- maybe the solution will be to dynamically generate a config like this given a command like
                   -- :DebugPyMod and it'll use lua code to find the relative path to the module, remove the .py
                   -- extension, convert "/" to ".", etc. and then call vimspector#LaunchWithConfigurations. For now
                   -- you just have to manually type in the module name.
                   module = "${ModuleName}",
                   -- Assumes the code is all under src and you need to be in that directory in order to import things
                   -- correctly.
                   cwd = "./src",
               },
               breakpoints = {
                   exception = {
                     raised = "N",
                     caught = "N",
                     uncaught = "Y",
                     userUnhandled = "N"
                   }
               }
           },
           ["Py Test"] = {
               adapter = "debugpy",
               configuration = {
                   name = "run the test",
                   module = "pytest",
                   type = "python",
                   request = "launch",
                   python = find_python(),
                   args = { "-q", "${file}" },
               },
               breakpoints = {
                   exception = {
                     raised = "N",
                     caught = "N",
                     uncaught = "Y",
                     userUnhandled = "N"
                   }
               }
           },
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
