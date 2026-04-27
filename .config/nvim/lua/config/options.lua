local opt = vim.opt

-- Editing
opt.backspace = { 'indent', 'eol', 'start' }
opt.smarttab = true
opt.tabstop = 3
opt.shiftwidth = 3
opt.expandtab = true
opt.textwidth = 120
opt.wrap = true
opt.linebreak = true

-- Search
opt.incsearch = true
opt.ignorecase = true
opt.showmatch = true

-- UI
opt.ruler = true
opt.showcmd = false
opt.laststatus = 2
opt.statusline = '%m [File: %f] [Type: %Y] [Col: %03v] [Line: %04l of %L]'
opt.wildmode = { 'longest', 'list' }
opt.signcolumn = 'yes'

-- Behaviour
opt.autoread = true
opt.mouse = 'a'
opt.history = 50
opt.hidden = true
opt.shortmess:append('c')

-- Use system clipboard (OS-aware)
if vim.fn.system('uname -s') == 'Darwin\n' then
   opt.clipboard = 'unnamed'
else
   opt.clipboard = 'unnamedplus'
end

-- Backups / swap
opt.updatecount = 0
opt.writebackup = true
opt.backup = false

-- netrw
vim.g.netrw_liststyle = 1
vim.g.netrw_list_hide = [[^\./,^\.\.\/]]

-- Syntax / filetype
vim.cmd('filetype plugin indent on')
if vim.o.termguicolors or vim.fn.has('gui_running') == 1 then
   vim.cmd('syntax on')
end

-- Konsole/Neovim guicursor bug workaround
if not vim.g.fvim_loaded then
   opt.guicursor = ''
end

-- Jump to last cursor position when opening a buffer
vim.api.nvim_create_autocmd('BufReadPost', {
   callback = function()
      local line = vim.fn.line("'\"")
      if line > 0 and line <= vim.fn.line('$') then
         vim.cmd([[normal g`"]])
      end
   end,
})

-- Enter insert mode at top of git commit messages
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
   pattern = '*/COMMIT_EDITMSG',
   command = '1 | start',
})
