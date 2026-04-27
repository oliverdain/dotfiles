local function get_go_dir()
   local workspace_path = vim.fn.findfile('dodo.py', ';')
   local workspace_dir = vim.fn.fnamemodify(workspace_path, ':p:h')
   return workspace_dir .. '/go'
end

local function call_go(...)
   local workspace_dir = get_go_dir()
   local args = { ... }
   local cmd = #args == 0 and 'go build ./...' or ('go ' .. table.concat(args, ' '))
   vim.cmd(':AsyncRun -cwd=' .. workspace_dir .. ' python3 ./build-support/libs.py run -f compile -- ' .. cmd)
end

vim.api.nvim_create_autocmd('FileType', {
   pattern = 'go',
   callback = function()
      vim.opt_local.expandtab = false
      vim.opt_local.textwidth = 120
      vim.opt_local.tabstop = 4
      vim.opt_local.shiftwidth = 4
      vim.opt_local.spell = true
      -- m`/`` saves and restores position around goimports reformatting
      vim.keymap.set('n', '<leader>f', [[m`:%!goimports<CR>``]], { buffer = true })
      vim.keymap.set('n', '<C-]>', '<Plug>(coc-definition)', { buffer = true, silent = true })
   end,
})

vim.api.nvim_create_user_command('O', function(opts)
   local args = opts.args ~= '' and vim.split(opts.args, ' ') or {}
   call_go(unpack(args))
end, { nargs = '*', complete = 'file' })

vim.api.nvim_create_user_command('D', 'AsyncRun doit <args>', { nargs = '*', complete = 'file' })
vim.api.nvim_create_user_command('T', 'AsyncRun PANTS_COLORS=false PANTS_DYNAMIC_UI=false task <args>', { nargs = '*', complete = 'file' })
