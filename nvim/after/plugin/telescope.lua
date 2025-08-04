local builtin = require("telescope.builtin")
local actions = require("telescope.actions")

require("telescope").setup({
	defaults = {
		mappings = {
			i = {
				-- Navigate history with Ctrl+P/N
				["<C-p>"] = actions.cycle_history_prev,
				["<C-n>"] = actions.cycle_history_next,
				-- Navigate results with Ctrl+J/K  
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
			},
			n = {
				-- Navigate history with Ctrl+P/N
				["<C-p>"] = actions.cycle_history_prev,
				["<C-n>"] = actions.cycle_history_next,
				-- Navigate results with Ctrl+J/K
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
			},
		},
	},
})

vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
-- git files search på Ctrl + p, dette søger efter alle git filer
vim.keymap.set("n", "<C-p>", builtin.git_files, {})
-- Continue telescope (resume last picker)
vim.keymap.set("n", "<leader>pr", builtin.resume, {})
vim.keymap.set("n", "<leader>ps", function()
	builtin.live_grep({
		additional_args = function()
			return { "--fixed-strings" }
		end,
	})
end)
vim.keymap.set("n", "<leader>pb", builtin.buffers)
