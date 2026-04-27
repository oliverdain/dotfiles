return {
   {
      "neoclide/coc.nvim",
      branch = "release",
      config = function()
         -- Run CocInstall once per machine
         local utils = require("utils")
         utils.run_once("coc", function()
            vim.cmd([[:CocInstall coc-json coc-yaml coc-markdownlint coc-explorer coc-sh coc-pyright]])
            vim.cmd([[:CocInstall coc-lists coc-html coc-tsserver coc-go]])
            vim.cmd([[:CocInstall coc-kotlin]])
         end)

         vim.api.nvim_create_user_command('Format', "call CocAction('format')", { nargs = 0 })

         local function check_back_space()
            local col = vim.fn.col('.') - 1
            return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
         end

         local expr_opts = { silent = true, noremap = true, expr = true, replace_keycodes = false }

         -- TAB: advance through completion menu, or insert a real tab
         vim.keymap.set('i', '<TAB>', function()
            if vim.fn['coc#pum#visible']() == 1 then
               return vim.fn['coc#pum#next'](1)
            elseif check_back_space() then
               return '<TAB>'
            else
               return vim.fn['coc#refresh']()
            end
         end, expr_opts)
         vim.keymap.set('i', '<S-TAB>', [[pumvisible() ? "\<C-p>" : "\<C-h>"]], expr_opts)

         -- <CR> confirms the selected completion item
         vim.keymap.set('i', '<CR>', [[pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], expr_opts)

         -- <C-Space> triggers completion
         if vim.fn.has('nvim') == 1 then
            vim.keymap.set('i', '<C-space>', 'coc#refresh()', { silent = true, expr = true })
         else
            vim.keymap.set('i', '<C-@>', 'coc#refresh()', { silent = true, expr = true })
         end

         -- GoTo navigation
         vim.keymap.set('n', 'gd', '<Plug>(coc-definition)', { silent = true })
         vim.keymap.set('n', 'gy', '<Plug>(coc-type-definition)', { silent = true })
         vim.keymap.set('n', 'gi', '<Plug>(coc-implementation)', { silent = true })
         vim.keymap.set('n', 'gr', '<Plug>(coc-references)', { silent = true })
         vim.keymap.set('n', 'go', ':CocList outline<CR>', { silent = true })
         vim.keymap.set('n', 'gs', ':CocList symbols<CR>', { silent = true })

         -- K shows documentation
         vim.keymap.set('n', 'K', function()
            local ft = vim.bo.filetype
            if ft == 'vim' or ft == 'help' then
               vim.cmd('h ' .. vim.fn.expand('<cword>'))
            elseif vim.fn['coc#rpc#ready']() then
               vim.fn.CocActionAsync('doHover')
            else
               vim.cmd('!' .. vim.o.keywordprg .. ' ' .. vim.fn.expand('<cword>'))
            end
         end, { silent = true })

         -- Refactoring
         vim.keymap.set('n', '<leader>rn', '<Plug>(coc-rename)')
         vim.keymap.set({ 'n', 'x' }, '<leader>f', '<Plug>(coc-format-selected)')
         vim.keymap.set({ 'n', 'x' }, '<leader>a', '<Plug>(coc-codeaction-selected)')
         vim.keymap.set('n', '<leader>ac', '<Plug>(coc-codeaction-cursor)')
         vim.keymap.set('n', '<leader>as', '<Plug>(coc-codeaction-source)')
         vim.keymap.set('n', '<leader>qf', '<Plug>(coc-fix-current)')

         -- Diagnostics
         vim.keymap.set('n', '<leader>e', ':CocList diagnostics<CR>', { silent = true })
         vim.keymap.set('n', '<leader>d', ':CocDiagnostics<CR>', { silent = true })

         -- Python import sorting
         vim.keymap.set('n', '<leader>i', function()
            vim.fn.CocAction('runCommand', 'python.sortImports')
         end, { silent = true })
      end,
   },
}
