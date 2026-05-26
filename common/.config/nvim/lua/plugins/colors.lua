vim.pack.add({"https://github.com/rose-pine/neovim"})

require("rose-pine").setup({
  variant = "dawn",
  styles = {
    transparency = false,
  },
})

vim.cmd([[colorscheme rose-pine-dawn]])
