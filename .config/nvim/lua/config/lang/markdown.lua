vim.g.vim_markdown_folding_level = 6

vim.api.nvim_create_autocmd('FileType', {
   pattern = 'markdown',
   callback = function()
      vim.opt_local.textwidth = 120
      vim.opt_local.spell = true
      vim.opt_local.foldlevel = 6
   end,
})

vim.api.nvim_create_autocmd('FileType', {
   pattern = 'text',
   callback = function()
      vim.opt_local.textwidth = 120
      vim.opt_local.spell = true
   end,
})

-- Position at top for git commit files opened directly (not via COMMIT_EDITMSG autocmd)
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
   pattern = '*.git/COMMIT_EDITMSG',
   command = '1',
})
