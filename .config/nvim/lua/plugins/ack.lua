return {
   {
      "mileszs/ack.vim",
      lazy = false,
      init = function()
         if vim.fn.executable("rg") then
            vim.cmd([[let g:ackprg = 'rg --vimgrep']])
         end
      end
   },
}
