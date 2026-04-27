vim.api.nvim_create_autocmd('FileType', {
   pattern = { 'typescript', 'typescriptreact' },
   callback = function()
      vim.opt_local.tabstop = 4
      vim.opt_local.shiftwidth = 4
      vim.keymap.set('n', '<C-]>', '<Plug>(coc-definition)', { buffer = true, silent = true })
   end,
})
