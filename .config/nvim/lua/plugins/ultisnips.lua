return {
   {
      "SirVer/ultisnips",
      lazy=false,
      init = function()
         vim.g.UltiSnipsSnippetDirectories = { "UltiSnips" }
         vim.cmd([[let g:UltiSnipsExpandTrigger = '<C-j>']])
      end
   }
}
