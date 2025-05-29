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
