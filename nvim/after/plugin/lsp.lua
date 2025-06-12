-- Main LSP configuration file (consolidating mason.lua and lspconfig.lua)
local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local mason_tool_installer = require("mason-tool-installer")
local lspconfig = require("lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")

-- Define all servers we want to use
local servers = {
	"ts_ls",
	"html",
	"cssls",
	"tailwindcss",
	"lua_ls",
	"graphql",
	"emmet_ls",
	"pyright",
	-- "omnisharp",
	"csharp_ls",
	"ruby_lsp",
	"sorbet",
	"eslint",
	"marksman",
	"jsonls",
	"jedi_language_server",
	"sqls",
}

-- Enable mason and configure icons
mason.setup({
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
})

-- Configure mason-lspconfig
mason_lspconfig.setup({
	ensure_installed = servers,
	automatic_installation = true,
	automatic_enable = false,
})

-- Configure mason-tool-installer
mason_tool_installer.setup({
	ensure_installed = {
		-- Formatters
		"stylua", -- Lua formatter
		"prettierd", -- JS/TS/CSS/HTML/JSON/YAML/Markdown formatter
		"black", -- Python formatter
		"isort", -- Python import formatter
		"shfmt", -- Shell formatter

		-- Linters
		"jsonlint", -- JSON linter
		"eslint_d", -- JS/TS linter
		"luacheck", -- Lua linter
		"pylint", -- Python linter
		"stylelint", -- CSS linter
		"htmlhint", -- HTML linter
		"yamllint", -- YAML linter
		"markdownlint", -- Markdown linter
		"biome", -- JSON linter
		"shellcheck", -- Shell linter
	},
})

-- Add completion capabilities
local capabilities = cmp_nvim_lsp.default_capabilities()

-- Server-specific settings
local server_settings = {
	-- Lua LSP configuration
	lua_ls = {
		settings = {
			Lua = {
				diagnostics = {
					globals = { "vim" },
				},
				workspace = {
					library = vim.api.nvim_get_runtime_file("", true),
					checkThirdParty = false,
				},
				completion = {
					callSnippet = "Replace",
				},
			},
		},
	},

	-- Ruby LSP configuration
	ruby_lsp = {
		init_options = {
			formatter = "auto",
			enabledFeatures = {
				formatting = true,
			},
		},
	},

	sorbet = {
		cmd = { "srb", "tc", "--lsp" },
		filetypes = { "ruby" },
		root_dir = require("lspconfig").util.root_pattern("sorbet/config"),
		autostart = true,
	},

	-- omnisharp = {
	-- 	cmd = {
	-- 		"dotnet",
	-- 		vim.fn.stdpath("data") .. "/mason/packages/omnisharp/OmniSharp.dll",
	-- 		"--languageserver",
	-- 		"--hostPID",
	-- 		tostring(vim.fn.getpid()),
	-- 	},
	-- 	root_dir = require("lspconfig").util.root_pattern(
	-- 		"*.sln",
	-- 		"*.csproj",
	-- 		"omnisharp.json",
	-- 		"Directory.Build.props",
	-- 		"Assets", -- Unity-specific directory
	-- 		"ProjectSettings" -- Unity-specific directory
	-- 	),
	-- 	settings = {
	-- 		-- Unity-specific settings
	-- 		MsBuild = {
	-- 			UseLegacySdkResolver = true, -- Needed for Unity
	-- 			EnableImportCompletion = true,
	-- 			LoadProjectsOnDemand = true,
	-- 		},
	-- 		FileOptions = {
	-- 			ExcludeSearchPatterns = { "**/obj/**", "**/bin/**", "**/Library/**", "**/Temp/**" }, -- Add Unity folders
	-- 			AnalyzeOpenDocumentsOnly = false, -- Set to false for Unity
	-- 		},
	-- 		Sdk = {
	-- 			IncludePrereleases = true,
	-- 		},
	-- 	},
	-- 	on_attach = function(client, bufnr)
	-- 		-- Unity-specific configuration can go here
	-- 		client.server_capabilities.semanticTokensProvider = nil -- Disable semantic tokens for Unity projects
	-- 	end,
	-- },

	csharp_ls = {
		settings = {
			csharp = {
				format = {
					enable = true,
				},
			},
		},
	},
	-- Add more specific server settings as needed
}

-- Default configuration for all servers
local default_config = {
	capabilities = capabilities,
}

-- Setup all servers with respective configurations
for _, server_name in ipairs(servers) do
	-- Check if we have custom settings for this server
	local config = vim.tbl_deep_extend("force", default_config, server_settings[server_name] or {})
	lspconfig[server_name].setup(config)
end

-- LSP keybindings
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(event)
		local opts = { buffer = event.buf, remap = false }

		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "<leader>vd", function()
			vim.diagnostic.open_float()
		end, opts)
		vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
		vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
		vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
		vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
	end,
})

-- Basic diagnostic configuration
vim.diagnostic.config({
	virtual_text = true,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "E",
			[vim.diagnostic.severity.WARN] = "W",
			[vim.diagnostic.severity.HINT] = "H",
			[vim.diagnostic.severity.INFO] = "I",
		},
	},
	underline = true,
	update_in_insert = false,
	severity_sort = true,
})
