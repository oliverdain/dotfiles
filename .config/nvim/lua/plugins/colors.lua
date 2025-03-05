return {
  {
     "folke/tokyonight.nvim",
     lazy = true,
     opts = { style = "moon" },
     priority = 1000
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
     config = function()
       require("vague").setup()
       vim.cmd([[colorscheme vague]])
     end
  }
}
