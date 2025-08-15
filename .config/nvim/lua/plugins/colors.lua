return {
  {
     "folke/tokyonight.nvim",
     lazy = true,
     opts = { style = "moon" },
     priority = 1000,
  },
  {
     "catppuccin/nvim",
     name = "catppuccin",
     priority = 1000,
  },
  {
     "EdenEast/nightfox.nvim",
     lazy = false,
     priority = 1000,
  },
  {
     "vague2k/vague.nvim",
     lazy = false,
     priority = 1000,
     init = function()
        vim.cmd([[colorscheme vague]])
        -- The diff theme made it very hard to see diffs. This helps.
        vim.api.nvim_set_hl(0, 'DiffAdd', { bg = '#2d4a2d', fg = '#a3d977' })
        vim.api.nvim_set_hl(0, 'DiffDelete', { bg = '#4a2d2d', fg = '#f87171' })
        vim.api.nvim_set_hl(0, 'DiffChange', { bg = '#3d3d2d', fg = '#fbbf24' })
        vim.api.nvim_set_hl(0, 'DiffText', { bg = '#4a4a2d', fg = '#fbbf24', bold = true })
     end,
  },
  {
     "NLKNguyen/papercolor-theme",
     lazy = false,
     priority = 1000,
     -- config = function()
     --    -- Underline instead of highlight spelling errors
     --    vim.cmd([[autocmd ColorScheme * hi clear SpellBad | hi SpellBad cterm=underline gui=underline]])
     -- end
  }
}
