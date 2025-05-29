return {
   {
      "neoclide/coc.nvim",
      branch="release",
      config = function()
         local utils = require("utils")
         utils.run_once("coc", function()
            vim.cmd([[:CocInstall coc-json coc-yaml coc-markdownlint coc-explorer coc-sh coc-pyright]])
            vim.cmd([[:CocInstall coc-lists coc-html coc-tsserver coc-go]])
            vim.cmd([[:CocInstall coc-kotlin]])
         end)
      end
   }
}
