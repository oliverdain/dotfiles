local fontsize = 12

local function set_font_size(size)
   fontsize = size
   if vim.g.neovide then
      vim.cmd('set guifont=DejaVu\\ Sans\\ Mono:h' .. fontsize)
   else
      vim.cmd('GuiFont! DejaVu\\ Sans\\ Mono:h' .. fontsize)
   end
end

local function adjust_font_size(amount)
   set_font_size(fontsize + amount)
end

if vim.g.neovide then
   vim.g.neovide_cursor_animate_in_insert_mode = false
   vim.g.neovide_position_animation_length = 0.01
   vim.g.neovide_scroll_animation_length = 0.01
   vim.g.neovide_cursor_animation_length = 0.01
   vim.api.nvim_set_hl(0, 'StatusLine', { fg = '#cdcdcd', bg = '#2f2f72' })
   vim.api.nvim_set_hl(0, 'StatusLineNC', { fg = '#cdcdcd', bg = '#252530' })
   set_font_size(9)
end

-- gvim cursor invisibility workaround
if not vim.fn.has('gui_vimr') then
   vim.o.guifont = vim.o.guifont
end

vim.keymap.set('n', '<C-+>', function() adjust_font_size(1) end)
vim.keymap.set('n', '<C-->', function() adjust_font_size(-1) end)
vim.keymap.set('n', '<C-0>', function() set_font_size(12) end)
