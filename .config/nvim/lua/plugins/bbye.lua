return {
   "moll/vim-bbye",
   config = function()
      vim.api.nvim_create_user_command("Bc", "Bdelete", {})
   end
}
