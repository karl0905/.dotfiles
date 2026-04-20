vim.pack.add({ "https://github.com/folke/snacks.nvim" })

require("snacks").setup({
	-- indent ###########
	indent = {
		enabled = true,
		char = "│",
		blank = " ",
		scope = {
			enabled = true,
			char = "│",
			underline = false,
			hl = "SnacksIndentScope",
		},
		chunk = {
			enabled = false,
		},
		animate = {
			enabled = false,
		},
	},
	input = { enabled = false },
	quickfile = { enabled = false },
	scroll = { enabled = false },
	statuscolumn = { enabled = false },
	words = { enabled = false },
	styles = {},
})
