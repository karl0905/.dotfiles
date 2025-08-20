local conform = require("conform")
conform.setup({
	formatters_by_ft = {
		javascript = { "eslint_d" },
		typescript = { "eslint_d" },
		javascriptreact = { "eslint_d" },
		typescriptreact = { "eslint_d" },
		svelte = { "eslint_d" },
		css = { "eslint_d" },
		html = { "eslint_d" },
		json = { "prettierd" },
		yaml = { "prettierd" },
		markdown = { "markdownlint" },
		graphql = { "eslint_d" },
		lua = { "stylua" },
		python = { "isort", "ruff" },
		sh = { "shfmt" },
		bash = { "shfmt" },
    typst = { "typstyle" },
	},
	formatters = {
		csharpier = {
			command = "csharpier",
			args = { "format", "$FILENAME" },
			stdin = false,
		},
	},
	-- format_on_save = {
	-- 	lsp_fallback = true,
	-- 	async = false,
	-- 	timeout_ms = 1000,
	-- },
})

vim.keymap.set({ "n", "v" }, "<leader>f", function()
	conform.format({
		lsp_fallback = true,
		async = false,
		timeout_ms = 1000,
	})
end, { desc = "Format file or range (in visual mode)" })
