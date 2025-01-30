return {
   -- A collection of colorschemes
   "flazz/vim-colorschemes",
   {
      "NLKNguyen/papercolor-theme",
      priority = 1000,
      lazy = false,
      init = function()
         -- Color scheme and underline spelling errors instead of highlighting them
         -- Other colorscheme's I've liked: apprentice and jellybean
         -- The spelling color scheme for PaperColor is awful so change it.
         -- Experimentally I needed a autocmd 'cause I think when you load a file that
         -- has syntax highlighting the colorscheme changes which would otherwise wipe
         vim.cmd([[set background=dark]])
         vim.cmd([[colorscheme PaperColor]])
         vim.cmd([[autocmd ColorScheme * hi clear SpellBad | hi SpellBad cterm=underline gui=underline]])
      end
   },
}
