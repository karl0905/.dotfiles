local lint = require("lint")
lint.linters_by_ft = {
	javascript = { "eslint_d" },
	typescript = { "eslint_d" },
	javascriptreact = { "eslint_d" },
	typescriptreact = { "eslint_d" },
	svelte = { "eslint_d" },
	css = { "stylelint" },
	html = { "htmlhint" },
	json = { "biome" },
	yaml = { "yamllint" },
	markdown = { "markdownlint" },
	graphql = { "eslint_d" },
	lua = { "luacheck" },
	python = { "pylint" },
	ruby = { "rubocop" },
}

local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

vim.api.nvim_create_autocmd({
	"BufEnter",
	"BufWritePost",
	"InsertLeave",
	"TextChanged",
}, {
	group = lint_augroup,
	callback = function()
		lint.try_lint()
	end,
})

vim.keymap.set("n", "<leader>l", function()
	lint.try_lint()
end, { desc = "Lint current buffer" })
