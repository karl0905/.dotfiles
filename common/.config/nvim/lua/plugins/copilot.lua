vim.pack.add({ "https://github.com/zbirenbaum/copilot.lua" })

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
	panel = {
		enabled = false,
	},
})
