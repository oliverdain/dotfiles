return {
   "olimorris/codecompanion.nvim",
   dependencies = { "nvim-treesitter/nvim-treesitter" },
   init = function()
      vim.api.nvim_create_user_command("Ccc", "CodeCompanionChat <args>", {nargs="*"})
      vim.api.nvim_create_user_command("Cc", "CodeCompanion <args>", {nargs="*"})
   end
}
