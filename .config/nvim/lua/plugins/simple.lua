return {
   "whiteinge/diffconflicts",
   {
      "kien/ctrlp.vim",
      init = function()
         vim.g.ctrlp_open_new_file = 'r'
         if vim.fn.executable('ag') == 1 then
            vim.g.ctrlp_user_command = 'ag %s -l --nocolor -g ""'
         end
      end,
   },
   {
      "skywind3000/asyncrun.vim",
      init = function()
         vim.g.asyncrun_open = 8
      end,
   },
   { "junegunn/fzf.vim", dependencies = { "junegunn/fzf" } },
   {
      "francoiscabrol/ranger.vim",
      dependencies = { "rbgrouleff/bclose.vim" },
      init = function()
         vim.g.ranger_map_keys = 0
         vim.g.ranger_replace_netrw = 1
      end,
   },
   "tpope/vim-fugitive",
   "rbong/vim-flog",
   "preservim/vim-markdown",
   { "jesseleite/vim-agriculture", init = function()
      vim.g['agriculture#disable_smart_quoting'] = 1
   end },
}
