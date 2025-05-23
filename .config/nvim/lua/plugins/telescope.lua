return {
   {
      "nvim-telescope/telescope.nvim",
      tag = "0.1.8",
      priority = 100,
      dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
      config = function()
         require("telescope").setup()
         local builtin = require('telescope.builtin')
         vim.keymap.set("n", ",b", ":Telescope buffers<CR>")
         -- -- Live grep starting from pwd
         vim.keymap.set("n", ",g", builtin.live_grep)
         -- -- -- Live grep starting from the directory of the current file.
         vim.keymap.set("n", ",l", function() builtin.live_grep{cwd="%:p:h"} end)
         vim.keymap.set("n", ",h", builtin.help_tags)
      end
   },
   -- CoC plugin for Telescope
   {
      "fannheyward/telescope-coc.nvim",
      priority = 99,
      config = function()
         require("telescope").load_extension("coc")
      end
   },
   --  More powerful file browser
   {
      "nvim-telescope/telescope-file-browser.nvim",
      dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
      config = function()
         ts = require("telescope")
         ts.load_extension "file_browser"
         fb = ts.extensions.file_browser
         -- Search in the same directory as the current file
         vim.keymap.set("n", ",c", function()
            fb.file_browser{ depth = 1, path="%:p:h" }
         end)
         -- Search in the current working directory
         vim.keymap.set("n", ",p", function()
            fb.file_browser{ auto_depth = true }
         end)
      end
   }
 }
