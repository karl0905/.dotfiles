-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd([[packadd packer.nvim]])

return require("packer").startup(function(use)
  -- Packer can manage itself
  use("wbthomason/packer.nvim")

  -- small plugins without any configuration other than keybinds
  use("tpope/vim-repeat")
  use("tpope/vim-fugitive")
  use("christoomey/vim-tmux-navigator")
  use("nvim-tree/nvim-web-devicons")
  use("wesQ3/vim-windowswap")
  use({
    "nvzone/typr",
    requires = {
      "nvzone/volt",
    },
  })
  use({
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  })
  use({
    "kylechui/nvim-surround",
    tag = "*", -- Use for stability; omit to use `main` branch for the latest features
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end,
  })
  use({
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({})
    end,
  })
  -- better godot indentation
  use({
    "habamax/vim-godot",
    ft = { "gd", "gdscript", "gdscript3" },
    event = "VimEnter",
  })

  -- LSP
  use("williamboman/mason.nvim")
  use("williamboman/mason-lspconfig.nvim")
  use("neovim/nvim-lspconfig")
  use("hrsh7th/cmp-nvim-lsp")
  use({
    "antosha417/nvim-lsp-file-operations",
    config = function()
      require("lsp-file-operations").setup()
    end,
  })
  use("WhoIsSethDaniel/mason-tool-installer")
end)
