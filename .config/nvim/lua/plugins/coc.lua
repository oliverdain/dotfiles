return {
   {
      "neoclide/coc.nvim",
      branch="release",
      build = function()
         vim.cmd([[:CocInstall coc-json coc-yaml coc-markdownlint coc-explorer coc-sh coc-pyright]])
         vim.cmd([[:CocInstall coc-lists coc-html coc-tsserver coc-go]])
      end
   }
}
