return {
   -- A collection of colorschemes
   "flazz/vim-colorschemes",
   {
      "NLKNguyen/papercolor-theme",
      priority = 1000,
      lazy = false,
      -- The setup here is a little odd. For some reason if I put the colorscheme line as a config function it'd set the
      -- colorscheme (e.g. :colorscheme would show the right string) but it wouldn't take effect. But putting it in init
      -- made it take effect only like 1/2 the time - totally at random *something* would change the colorscheme but I
      -- couldn't figure out what. So we *also* put a UIEnter autocmd in the config block to re-load the colorscheme if
      -- something did overwrite it.
      init = function()
         -- Color scheme and underline spelling errors instead of highlighting them
         -- Other colorscheme's I've liked: apprentice and jellybean
         -- The spelling color scheme for PaperColor is awful so change it.
         -- Experimentally I needed a autocmd 'cause I think when you load a file that
         -- has syntax highlighting the colorscheme changes which would otherwise wipe
         vim.cmd([[set background=dark]])
         vim.cmd([[colorscheme PaperColor]])
         vim.cmd([[autocmd ColorScheme * hi clear SpellBad | hi SpellBad cterm=underline gui=underline]])
      end,
      config = function()
         vim.api.nvim_create_autocmd("VimEnter", {
           callback = function()
               vim.cmd([[set background=dark]])
               vim.cmd([[colorscheme PaperColor]])
               vim.cmd([[autocmd ColorScheme * hi clear SpellBad | hi SpellBad cterm=underline gui=underline]])
           end
         })
      end,
   },
}
