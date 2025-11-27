return {
   {
      "SirVer/ultisnips",
      lazy=false,
      init = function()
         vim.g.UltiSnipsSnippetDirectories = { vim.fn.expand("~/.vim/UltiSnips") }
         vim.cmd([[let g:UltiSnipsExpandTrigger = '<C-j>']])
      end
   }
}
