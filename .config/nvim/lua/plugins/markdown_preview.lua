return {
   {
       "iamcco/markdown-preview.nvim",
       cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
       ft = { "markdown" },
       config = function()
         local utils = require("utils")
         utils.run_once("markdown-preview", function()
            vim.fn["mkdp#util#install"]()
         end)
       end,
   }
}
