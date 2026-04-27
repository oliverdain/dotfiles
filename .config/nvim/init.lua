-- Python host programs (Linux; macOS handles this automatically)
if vim.fn.filereadable('/usr/local/bin/python3') == 0 then
   vim.g.python2_host_prog = '/usr/bin/python'
   vim.g.python3_host_prog = '/usr/bin/python3'
end

-- Include ~/.vim so UltiSnips, indent files, spell files, etc. are found
vim.opt.runtimepath:prepend(vim.fn.expand('~/.vim'))
vim.opt.runtimepath:append(vim.fn.expand('~/.vim/after'))
vim.opt.packpath = vim.o.runtimepath

-- mapleader must be set before lazy loads plugins
vim.g.mapleader = '\\'
vim.g.maplocalleader = '\\'

require('config.lazy')
require('config.options')
require('config.keymaps')
require('config.gui')
require('config.lang.python')
require('config.lang.go')
require('config.lang.typescript')
require('config.lang.cpp')
require('config.lang.markdown')
