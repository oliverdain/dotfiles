-- this hold "simple plugins" that need essentially no configuration.
return {
   "whiteinge/diffconflicts",
   "kien/ctrlp.vim",
   "skywind3000/asyncrun.vim",
  { "junegunn/fzf.vim", dependencies = { "junegunn/fzf" } },
  { "francoiscabrol/ranger.vim", dependencies = { "rbgrouleff/bclose.vim" } },
  "tpope/vim-fugitive",
  "rbong/vim-flog",
  "preservim/vim-markdown",
}
