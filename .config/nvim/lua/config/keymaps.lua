local map = vim.keymap.set

-- Clipboard
map('v', '<C-c>', '"+y')
map('i', '<C-v>', '<Esc>"+pa')

-- Terminal: Escape exits terminal mode
if vim.fn.has('nvim') == 1 then
   map('t', '<Esc>', [[<C-\><C-n>]])
end

-- Blank lines above/below without entering insert mode
map('n', '<leader>o', 'o<Esc>')
map('n', '<leader>O', 'O<Esc>')

-- Close quickfix, location list, and preview window
map('n', '<leader>c', ':ccl<CR> | :pc<CR> | :lclose<CR>')

-- Quickfix navigation
map('n', '<F7>', ':cprevious<CR>')
map('n', '<F8>', ':cnext<CR>')

-- Emacs-style insert mode navigation
map('i', '<C-e>', '<Esc>$a')
map('i', '<C-a>', '<Esc>0i')
map('i', '<C-u>', '<Esc>ld0i')
map('i', '<C-k>', '<Esc>ld$a')

-- Save from insert and normal mode
map('i', '<C-s>', '<Esc>:w<CR>a')
map('n', '<C-s>', ':w<CR>')

-- Sort the block (blank-line delimited) around the cursor
map('n', '<leader>s', '{jV}k :!sort<CR>')

-- Commands
vim.api.nvim_create_user_command('Killws', [[% s/\s\+$//g]], {})

vim.api.nvim_create_user_command('F', 'FZF <args>', { nargs = 1, complete = 'dir' })

-- Yank current file path into a register (default: system clipboard)
vim.api.nvim_create_user_command('Yp', function(opts)
   local reg = opts.args ~= '' and opts.args or '+'
   vim.fn.setreg(reg, vim.fn.expand('%'))
end, { nargs = '?' })

-- Yank current file's directory into a register (default: system clipboard)
vim.api.nvim_create_user_command('Yd', function(opts)
   local reg = opts.args ~= '' and opts.args or '+'
   vim.fn.setreg(reg, vim.fn.expand('%:h'))
end, { nargs = '?' })
