local function find_mypy_root()
   local thisdir = vim.fn.expand('%:p:h')
   local mypyfile = vim.fn.findfile('.mypy.ini', thisdir .. ';')
   return vim.fn.fnamemodify(mypyfile, ':p:h')
end

local function call_mypy(...)
   local args = { ... }
   local cmd = #args == 0 and 'mypy' or ('mypy ' .. table.concat(args, ' '))
   vim.cmd(':AsyncRun echo Entering ' .. find_mypy_root() .. ' && ' .. cmd)
end

local function call_pants(...)
   local workspace_path = vim.fn.findfile('pants.toml', ';')
   local workspace_dir = vim.fn.fnamemodify(workspace_path, ':p:h')
   local args = { ... }
   local cmd = #args == 0 and './check.sh ::' or ('./pants ' .. table.concat(args, ' '))
   vim.cmd(':AsyncRun -cwd=' .. workspace_dir .. ' ' .. cmd)
end

vim.api.nvim_create_autocmd('FileType', {
   pattern = 'python',
   callback = function()
      vim.opt_local.errorformat:prepend('%.%#ERROR %f:%l:%c-%*[0-9]: %m,%.%#WARN %f:%l:%c-%*[0-9]: %m')
      vim.opt_local.expandtab = true
      vim.opt_local.textwidth = 120
      vim.opt_local.spell = true
      vim.b.coc_root_patterns = { 'pyrightconfig.json', '.git' }
      vim.keymap.set('n', '<C-]>', '<Plug>(coc-definition)', { buffer = true, silent = true })
   end,
})

-- Auto-insert copyright snippet for new Python files
vim.api.nvim_create_autocmd('BufNewFile', {
   pattern = '*.py',
   command = [[normal infc<C-j>]],
})

vim.api.nvim_create_user_command('Mf', function()
   local curfile = vim.fn.substitute(vim.fn.expand('%:p'), find_mypy_root() .. '/', '', '')
   call_mypy(curfile)
end, {})

vim.api.nvim_create_user_command('Md', function()
   local curdir = vim.fn.substitute(vim.fn.expand('%:p:h'), find_mypy_root() .. '/', '', '')
   call_mypy(curdir)
end, {})

-- Sort contents of the innermost [] block (typically __all__ lists)
vim.api.nvim_create_user_command('Sa', [[normal! vi[:!sort<CR>]], {})

vim.api.nvim_create_user_command('P', function(opts)
   local args = opts.args ~= '' and vim.split(opts.args, ' ') or {}
   call_pants(unpack(args))
end, { nargs = '*', complete = 'file' })

-- Run Pants codegen for the whole repo
vim.api.nvim_create_user_command('Cg', function()
   call_pants('export-codegen', '::')
end, {})
