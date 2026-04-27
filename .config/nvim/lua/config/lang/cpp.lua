local function find_rel_to_subproject(fname)
   local thisdir = vim.fn.expand('%:p:h')
   local buildfile = vim.fn.findfile('WORKSPACE', thisdir .. ';')
   local builddir = vim.fn.fnamemodify(buildfile, ':p:h') .. '/cpp'
   return vim.fn.findfile(fname, builddir .. '/**')
end

local function edit_extension(ext)
   local newfile = find_rel_to_subproject(vim.fn.expand('%:t:r') .. ext)
   vim.cmd('e ' .. newfile)
end

local function call_bazel(...)
   local workspace_path = vim.fn.findfile('WORKSPACE', ';')
   local workspace_dir = vim.fn.fnamemodify(workspace_path, ':p:h')
   local args = { ... }
   local cmd = #args == 0 and 'bazel build ...' or ('bazel ' .. table.concat(args, ' '))
   vim.opt.errorformat = {
      '%-GC++ compilation of rule %.%#',
      '%DEntering %f',
      'ERROR: %f:%l:%c:%m',
      '%f:%l:%c:%m',
   }
   vim.cmd(':AsyncRun echo Entering ' .. workspace_dir .. ' && ' .. cmd)
end

vim.api.nvim_create_autocmd('FileType', {
   pattern = { 'c', 'cpp' },
   callback = function()
      vim.opt_local.spell = true
   end,
})

vim.api.nvim_create_user_command('Toh', function() edit_extension('.h') end, {})
vim.api.nvim_create_user_command('Toc', function() edit_extension('.cpp') end, {})
vim.api.nvim_create_user_command('Tot', function()
   local newfile = find_rel_to_subproject('test_' .. vim.fn.expand('%:t:r') .. '.cpp')
   vim.cmd('e ' .. newfile)
end, {})

vim.api.nvim_create_user_command('B', function(opts)
   local args = opts.args ~= '' and vim.split(opts.args, ' ') or {}
   call_bazel(unpack(args))
end, { nargs = '*', complete = 'file' })
