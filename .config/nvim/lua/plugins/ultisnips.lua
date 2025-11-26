return {
   {
      "SirVer/ultisnips",
      lazy=false,
      init = function()
         vim.g.UltiSnipsSnippetDirectories = { vim.fn.expand("~/.config/nvim/UltiSnips") }
         vim.cmd([[let g:UltiSnipsExpandTrigger = '<C-j>']])
      end
   }
}
