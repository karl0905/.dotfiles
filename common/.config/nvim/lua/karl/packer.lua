-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd([[packadd packer.nvim]])

return require("packer").startup(function(use)
	-- Packer can manage itself
	use("wbthomason/packer.nvim")

	use("tpope/vim-repeat")

	use({
		"nvim-treesitter/nvim-treesitter",
		run = function()
			local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
			ts_update()
		end,
	})
	use({
		"nvim-treesitter/nvim-treesitter-textobjects",
		after = "nvim-treesitter",
		requires = "nvim-treesitter/nvim-treesitter",
	})
	use("tpope/vim-fugitive")

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
	use({
		"folke/lazydev.nvim",
		ft = "lua",
		config = function()
			require("lazydev").setup({
				library = {
					{ path = "luvit-meta/library", words = { "vim%.uv" } },
				},
			})
		end,
	})
	use("WhoIsSethDaniel/mason-tool-installer")

	-- Linting
	use("mfussenegger/nvim-lint")

	use({
		"kylechui/nvim-surround",
		tag = "*", -- Use for stability; omit to use `main` branch for the latest features
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end,
	})
	use("jbyuki/instant.nvim")
	use({
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	})
	use({
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				suggestion = {
					enabled = true,
					auto_trigger = true,
					keymap = {
						accept = "<Tab>",
						next = "<C-b>",
						prev = "<C-v>",
					},
				},
				panel = { enabled = false },
			})
		end,
	})
	use("christoomey/vim-tmux-navigator")
	use("nvim-tree/nvim-web-devicons")
	use({
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	})

	-- vi-mongo.nvim
	use({
		"kopecmaciej/vi-mongo.nvim",
		config = function()
			require("vi-mongo").setup()
		end,
	})

	-- vim-windowswap
	use("wesQ3/vim-windowswap")

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

		-- typr
	use({
		"nvzone/typr",
		requires = {
			"nvzone/volt",
		},
	})

	-- better godot indentation
	use({
		"habamax/vim-godot",
		ft = { "gd", "gdscript", "gdscript3" },
		event = "VimEnter",
	})
end)
