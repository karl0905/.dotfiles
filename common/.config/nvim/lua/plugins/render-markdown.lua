vim.pack.add({ "https://github.com/MeanderingProgrammer/render-markdown.nvim" })

require("render-markdown").setup({
  -- requires = { "echasnovski/mini.nvim", opt = true }, -- if you use the mini.nvim suite
  -- requires = { 'echasnovski/mini.icons', opt = true }, -- if you use standalone mini plugins
  requires = { "nvim-tree/nvim-web-devicons", opt = true }, -- if you prefer nvim-web-devicons
})

-- Render markdown toggle
vim.keymap.set("n", "<leader>rm", ":RenderMarkdown toggle<CR>", { noremap = true, silent = true })
