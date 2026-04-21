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

	-- neotest
	use({
		"nvim-neotest/neotest",
		requires = {
			"olimorris/neotest-rspec",
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("neotest").setup({
				adapters = {
					require("neotest-rspec"),
				},
			})
		end,
	})

	--render-markdown.nvim
	use({
		"MeanderingProgrammer/render-markdown.nvim",
		after = { "nvim-treesitter" },
		-- requires = { "echasnovski/mini.nvim", opt = true }, -- if you use the mini.nvim suite
		-- requires = { 'echasnovski/mini.icons', opt = true }, -- if you use standalone mini plugins
		requires = { "nvim-tree/nvim-web-devicons", opt = true }, -- if you prefer nvim-web-devicons
		config = function()
			require("render-markdown").setup({})
		end,
	})
end)
